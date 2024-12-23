class CreateMedicalProcedures < ActiveRecord::Migration[8.0]
  def change
    create_table :medical_procedures do |t|
      t.date :date_complete
      t.boolean :complete
      t.date :date_planned
      t.text :notes
      t.references :animal, null: false, foreign_key: true
      t.references :procedure_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
