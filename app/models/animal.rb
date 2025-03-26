# == Schema Information
#
# Table name: animals
#
#  id                  :bigint           not null, primary key
#  arival_date         :date
#  birth_day           :date
#  birth_year          :date
#  color               :string
#  death_day           :date
#  death_year          :date
#  distinctive_feature :string
#  fake_parent         :boolean          default(FALSE)
#  from_people         :string
#  from_place          :string
#  gender              :string
#  graduation          :string
#  medical_history     :string
#  nickname            :string
#  size                :string
#  sterilization       :boolean          default(FALSE)
#  surname             :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  animal_status_id    :bigint
#  animal_type_id      :bigint           not null
#  aviary_id           :bigint
#  fake_parent_id      :integer
#  parent_id           :integer
#  section_id          :bigint
#
# Indexes
#
#  index_animals_on_animal_status_id  (animal_status_id)
#  index_animals_on_animal_type_id    (animal_type_id)
#  index_animals_on_aviary_id         (aviary_id)
#  index_animals_on_section_id        (section_id)
#
# Foreign Keys
#
#  fk_rails_...  (animal_type_id => animal_types.id)
#
class Animal < ApplicationRecord
  extend ApplicationHelper
  belongs_to :animal_type
  belongs_to :aviary, optional: true
  belongs_to :section, optional: true
  belongs_to :animal_status
  has_many :cart_animals
  has_many :carts, through: :cart_animals, dependent: :destroy
  has_many :notes, as: :noteable, dependent: :destroy
  has_many :children, class_name: 'Animal', foreign_key: 'parent_id'
  belongs_to :parent, class_name: 'Animal', optional: true

  has_one :action_text_rich_text,
    class_name: 'ActionText::RichText',
    as: :record

  has_many_attached :pictures do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 640, 480 ]
  end
  include AppendToHasManyAttached['pictures']

  has_many :medical_procedures, dependent: :destroy

  before_save :strip_whitespace_and_titleize

  validate :any_present?

  default_scope { where(fake_parent: false) }
  scope :shelter, -> { where(animal_status: 1) }
  scope :parents, -> { joins(:children).distinct }
  scope :fake_parents, -> { unscoped.where(fake_parent: true) }

  def display_name
    name = "#{self&.nickname} #{self&.surname}"
    if self.nickname.present?
      name += "(#{self.id})"
    else
      name += "#{self.id}"
    end
    name
  end

  def siblings
    if self.parent.present?
      self.parent.children.where.not(id: self.id)
    elsif self.fake_parent_id.present?
      Animal.unscoped.where(fake_parent_id: self.fake_parent_id).where.not(id: self.id)
    else
      Animal.none
    end
  end

  def dup
    super.tap do |new_animal|
      new_animal.nickname = nil
      if self.parent.present?
        new_animal.parent = self.parent
      end
    end
  end

  def self.to_csv
    fields = %w[ id nickname surname gender size parent_id animal_type_id sterilization aviary_id section_id animal_status_id arival_date color distinctive_feature from_people from_place
      graduation medical_history birth_year death_year ]
    header = %w[ id nickname surname gender size parent_id animal_type_id sterilization aviary_id section_id animal_status_id arival_date color distinctive_feature from_people from_place
      graduation medical_history birth_day death_day children siblings ]
    header_to_csv = header.map { |field| I18n.t("activerecord.attributes.animal.#{field}", default: field.humanize) }
    CSV.generate(headers: true) do |csv|
      csv << header_to_csv
      find_each do |animal|
        row = []
        fields.each do |field|
          value = case field
          when 'animal_type_id'
            animal.animal_type&.name
          when 'aviary_id'
            animal.aviary&.name
          when 'section_id'
            animal.section&.name
          when 'animal_status_id'
            animal.animal_status&.name
          when 'parent_id'
            animal.parent&.display_name
          when 'sterilization'
            animal.sterilization ? 'Yes' : ''
          when 'birth_year'
            show_birth_or_death_date(animal, 'birth')
          when 'death_year'
            show_birth_or_death_date(animal, 'death')
          when 'arival_date'
            show_date(animal.arival_date)
          else
            animal.attributes.values_at(field)[0]
          end
          row << value
        end
        if animal.children.present?
          row << animal.children.map(&:display_name).join(', ')
        else
          row << ''
        end
        if animal.siblings.present?
          row << animal.siblings.map(&:display_name).join(', ')
        else
          row << ''
        end
        csv << row
      end
    end
  end

  private

  def strip_whitespace_and_titleize
    if self.nickname.present?
      self.nickname = self.nickname.strip
      self.nickname = self.nickname.split(' ').map { |word| word.capitalize }.join(' ')
    end
    if self.surname.present?
      self.surname = self.surname.strip
      self.surname = self.surname.split(' ').map { |word| word.capitalize }.join(' ')
    end
  end

  def any_present?
    if %w[nickname surname color arival_date].all? { |attr| self[attr].blank? }
      errors.add :base, :any_present_message
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    [ 'id', 'nickname', 'surname', 'gender', 'size', 'arival_date', 'sterilization', 'distinctive_feature', 'color', 'medical_history', 'from_people', 'from_place', 'notes_body' ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ 'animal_type', 'animal_status', 'aviary', 'notes', 'rich_text_body' ]
  end

  ransacker :notes_body do |_parent|
    Arel.sql("(SELECT string_agg(action_text_rich_texts.body::text, ' ')
              FROM notes
              INNER JOIN action_text_rich_texts ON
                action_text_rich_texts.record_type = 'Note'
                AND action_text_rich_texts.record_id = notes.id
              WHERE notes.noteable_type = 'Animal'
                AND notes.noteable_id = animals.id)")
  end
end
