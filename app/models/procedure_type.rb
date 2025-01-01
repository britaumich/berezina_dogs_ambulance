class ProcedureType < ApplicationRecord
  has_many :medical_procedures
  
  def self.ransackable_attributes(auth_object = nil)
    ["id", "name"]
  end

end
