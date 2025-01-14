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
require 'rails_helper'

RSpec.describe MedicalProcedure, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
