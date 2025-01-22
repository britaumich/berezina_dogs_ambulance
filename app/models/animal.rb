# == Schema Information
#
# Table name: animals
#
#  id             :bigint           not null, primary key
#  arival_date    :date
#  birth_date     :date
#  color          :string
#  death_date     :date
#  description    :string
#  from_people    :string
#  from_place     :string
#  gender         :string
#  graduation     :string
#  history        :string
#  nickname       :string
#  sterilization  :boolean          default(FALSE)
#  surname        :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  animal_type_id :bigint           not null
#  aviary_id      :bigint
#  section_id     :bigint
#
# Indexes
#
#  index_animals_on_animal_type_id  (animal_type_id)
#  index_animals_on_aviary_id       (aviary_id)
#  index_animals_on_section_id      (section_id)
#
# Foreign Keys
#
#  fk_rails_...  (animal_type_id => animal_types.id)
#
class Animal < ApplicationRecord
  belongs_to :animal_type
  belongs_to :aviary, optional: true
  belongs_to :section, optional: true
  has_many :cart_animals
  has_many :carts, through: :cart_animals
  has_many :notes, as: :noteable

  has_one :action_text_rich_text,
    class_name: 'ActionText::RichText',
    as: :record

  has_many_attached :pictures do |attachable|
    attachable.variant :thumb, resize_to_limit: [640, 480]
  end
  include AppendToHasManyAttached['pictures']

  has_many :medical_procedures

  before_save :strip_whitespace_and_titleize

  validate :any_present?

  private

  def strip_whitespace_and_titleize
    if self.nickname.present?
      self.nickname = self.nickname.strip
      self.nickname = self.nickname.split(" ").map{|word| word.capitalize}.join(" ")
    end
    if self.surname.present?
      self.surname = self.surname.strip
      self.surname = self.surname.split(" ").map{|word| word.capitalize}.join(" ")
    end
  end

  def any_present?
    if %w(nickname surname color description arival_date).all?{|attr| self[attr].blank?}
      errors.add :base, :any_present_message
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    ["nickname", "surname", "gender", "arival_date", "sterilization", "description", "history", "from_people", "from_place", "notes_body"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["animal_type", "aviary", "notes", "rich_text_body" ]
  end

  ransacker :notes_body do |parent|
    Arel.sql("(SELECT string_agg(action_text_rich_texts.body::text, ' ')
              FROM notes
              INNER JOIN action_text_rich_texts ON 
                action_text_rich_texts.record_type = 'Note' 
                AND action_text_rich_texts.record_id = notes.id
              WHERE notes.noteable_type = 'Animal' 
                AND notes.noteable_id = animals.id)")
  end

end
