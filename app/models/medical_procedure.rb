class MedicalProcedure < ApplicationRecord
  belongs_to :animal
  belongs_to :procedure_type
  has_many :notes, as: :noteable

  def self.ransackable_attributes(auth_object = nil)
    ["date_complete", "date_planned", "animal_id", "procedure_type_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["animal", "procedure_type"]
  end
end
