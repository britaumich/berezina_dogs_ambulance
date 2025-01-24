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

  before_validation :strip_whitespace_and_downcase
  validates :name, presence: true, uniqueness: true
  
  private

  def strip_whitespace_and_downcase
    if self.name.present?
      self.name = self.name.strip.downcase
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end

end
