class CreateAnimals < ActiveRecord::Migration[8.0]
  def change
    create_table :animals do |t|
      t.string :nickname
      t.string :surname
      t.string :gender
      t.date :arival_date
      t.string :from_people
      t.string :from_place
      t.date :birth_year
      t.string :birth_month
      t.date :death_date
      t.string :color
      t.string :aviary
      t.string :description
      t.string :history
      t.string :graduation
      t.references :animal_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
