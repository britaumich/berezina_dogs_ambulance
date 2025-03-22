class AddIndexToAnimalType < ActiveRecord::Migration[8.0]
  def change
    add_index :animal_types, :name, unique: true
  end
end
