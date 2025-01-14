# == Schema Information
#
# Table name: animal_types
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class AnimalType < ApplicationRecord
  has_many :animals

  validates :name, presence: true, uniqueness: true

  def self.ransackable_associations(auth_object = nil)
    ["animals"]
  end

end
