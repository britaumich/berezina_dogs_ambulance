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

  has_many_attached :pictures do |attachable|
    attachable.variant :thumb, resize_to_limit: [640, 480]
  end
  include AppendToHasManyAttached['pictures']

  has_many :medical_procedures

  validate :any_present?

  def any_present?
    if %w(nickname surname color description arival_date).all?{|attr| self[attr].blank?}
      errors.add :base, :any_present_message
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    ["nickname", "surname", "gender", "arival_date", "aviary_id", "description", "history"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["animal_type"]
  end

end
