class AddAviaryToAnimal < ActiveRecord::Migration[8.0]
  def change
    add_reference :animals, :aviary, index: true
    add_reference :animals, :section, index: true
  end
end
