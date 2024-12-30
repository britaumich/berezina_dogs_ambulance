class MedicalProcedure < ApplicationRecord
  belongs_to :animal
  belongs_to :procedure_type
  has_many :notes, as: :noteable

end
