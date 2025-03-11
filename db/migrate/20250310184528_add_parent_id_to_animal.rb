class AddParentIdToAnimal < ActiveRecord::Migration[8.0]
  def change
    add_column :animals, :parent_id, :integer
  end
end
