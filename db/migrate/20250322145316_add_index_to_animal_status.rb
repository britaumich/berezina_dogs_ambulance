class AddIndexToAnimalStatus < ActiveRecord::Migration[8.0]
  def change
    add_index :animal_statuses, :name, unique: true
  end
end
