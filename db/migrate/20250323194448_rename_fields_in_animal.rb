class RenameFieldsInAnimal < ActiveRecord::Migration[8.0]
  def change
    rename_column :animals, :description, :distinctive_feature
    rename_column :animals, :history, :medical_history
  end
end
