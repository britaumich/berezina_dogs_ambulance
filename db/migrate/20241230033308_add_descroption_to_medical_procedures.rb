class AddDescroptionToMedicalProcedures < ActiveRecord::Migration[8.0]
  def change
    add_column :medical_procedures, :description, :string
  end
end
