# == Schema Information
#
# Table name: procedure_types
#
#  id          :bigint           not null, primary key
#  description :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class ProcedureType < ApplicationRecord
  has_many :medical_procedures

  validates :name, presence: true, uniqueness: true
  
  def self.ransackable_attributes(auth_object = nil)
    ["id", "name"]
  end

end
