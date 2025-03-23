class AddSizeToAnimal < ActiveRecord::Migration[8.0]
  def change
    add_column :animals, :size, :string
  end
end
