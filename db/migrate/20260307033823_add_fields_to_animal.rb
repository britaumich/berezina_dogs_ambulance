class AddFieldsToAnimal < ActiveRecord::Migration[8.0]
  def change
    add_column :animals, :chip, :string
    add_column :animals, :name_english, :string
    add_column :animals, :name_georgian, :string
  end
end
