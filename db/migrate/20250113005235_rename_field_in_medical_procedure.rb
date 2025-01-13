class RenameFieldInMedicalProcedure < ActiveRecord::Migration[8.0]
  def change
    rename_column :medical_procedures, :date_complete, :date_completed
  end
end
