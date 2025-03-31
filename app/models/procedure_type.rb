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
  has_many :medical_procedures, dependent: :restrict_with_exception

  before_validation :strip_whitespace_and_downcase
  validates :name, presence: true, uniqueness: true

  before_destroy :prevent_deletion_of_default_status

  private

  def strip_whitespace_and_downcase
    if self.name.present?
      self.name = self.name.strip.downcase
    end
  end

  def prevent_deletion_of_default_status
    if self.id == 1
      errors.add(:base, 'Cannot delete the default procedure type')
      throw(:abort)
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    [ 'name' ]
  end
end
