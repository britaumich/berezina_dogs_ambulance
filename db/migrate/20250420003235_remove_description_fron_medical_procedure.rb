class RemoveDescriptionFronMedicalProcedure < ActiveRecord::Migration[8.0]
  def change
    remove_column :medical_procedures, :description
  end
end
