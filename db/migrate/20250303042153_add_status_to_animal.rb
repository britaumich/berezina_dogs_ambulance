class AddStatusToAnimal < ActiveRecord::Migration[8.0]
  def change
    add_reference :animals, :animal_status, index: true
  end
end
