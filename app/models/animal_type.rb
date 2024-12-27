class AnimalType < ApplicationRecord
  has_many :animals

  def self.ransackable_associations(auth_object = nil)
    ["animals"]
  end


end
