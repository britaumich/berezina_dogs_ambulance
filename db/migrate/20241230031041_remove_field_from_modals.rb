class RemoveFieldFromModals < ActiveRecord::Migration[8.0]
  def change
    remove_column :medical_procedures, :notes
    remove_column :animals, :aviary
  end
end
