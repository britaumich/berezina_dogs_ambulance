class AddFakeParentToAnimal < ActiveRecord::Migration[8.0]
  def change
    add_column :animals, :fake_parent, :boolean, default: false
    add_column :animals, :fake_parent_id, :integer
  end
end
