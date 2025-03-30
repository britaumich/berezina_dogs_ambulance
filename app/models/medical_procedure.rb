# == Schema Information
#
# Table name: medical_procedures
#
#  id                :bigint           not null, primary key
#  complete          :boolean
#  date_completed    :date
#  date_planned      :date
#  description       :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  animal_id         :bigint           not null
#  procedure_type_id :bigint           not null
#
# Indexes
#
#  index_medical_procedures_on_animal_id          (animal_id)
#  index_medical_procedures_on_procedure_type_id  (procedure_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (animal_id => animals.id)
#  fk_rails_...  (procedure_type_id => procedure_types.id)
#
class MedicalProcedure < ApplicationRecord
  belongs_to :animal
  belongs_to :procedure_type
  has_many :notes, as: :noteable, dependent: :destroy

  after_save :if_sterilization
  before_destroy :if_sterilization_update_animal

  private

  def if_sterilization
    if self.procedure_type.name == 'стерилизация'
      if self.date_completed.present?
        Animal.find(self.animal_id).update(sterilization: true)
      else
        Animal.find(self.animal_id).update(sterilization: false)
      end
    end
  end

  def if_sterilization_update_animal
    if self.date_completed.present? && self.procedure_type.name == 'стерилизация'
      Animal.find(self.animal_id).update(sterilization: false)
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    [ 'date_completed', 'date_planned' ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ 'animal', 'procedure_type' ]
  end
end
