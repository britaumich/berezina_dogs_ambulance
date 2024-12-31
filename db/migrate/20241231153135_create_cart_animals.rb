class CreateCartAnimals < ActiveRecord::Migration[8.0]
  def change
    create_table :cart_animals do |t|
      t.belongs_to :animal, null: false, foreign_key: true
      t.belongs_to :cart, null: false, foreign_key: true

      t.timestamps
    end
  end
end
