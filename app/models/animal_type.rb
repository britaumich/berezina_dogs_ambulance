# == Schema Information
#
# Table name: animal_types
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_animal_types_on_name  (name) UNIQUE
#
class AnimalType < ApplicationRecord
  has_many :animals, dependent: :restrict_with_exception

  before_save :strip_whitespace_and_downcase
  validates :name, presence: true, uniqueness: true

  private

  def strip_whitespace_and_downcase
    if self.name.present?
      self.name = self.name.strip.downcase
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    [ 'name' ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ 'animals' ]
  end
end
