class CreateSections < ActiveRecord::Migration[8.0]
  def change
    create_table :sections do |t|
      t.string :name
      t.text :description
      t.references :aviary, null: false, foreign_key: true

      t.timestamps
    end
  end
end
