class AddFieldToAnimalType < ActiveRecord::Migration[8.0]
  def change
    add_column :animal_types, :plural_name, :string
  end
end
