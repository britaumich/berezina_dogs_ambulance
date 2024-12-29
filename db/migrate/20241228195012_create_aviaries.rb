class CreateAviaries < ActiveRecord::Migration[8.0]
  def change
    create_table :aviaries do |t|
      t.boolean :sections, default: false
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
