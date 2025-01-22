class AddSterilizationFieldToAnimal < ActiveRecord::Migration[8.0]
  def change
    add_column :animals, :sterilization, :boolean, default: false
  end
end
