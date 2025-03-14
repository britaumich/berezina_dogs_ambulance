class ChangeBirthAndDeathDatesInAnimal < ActiveRecord::Migration[8.0]
  def change
    rename_column :animals, :birth_date, :birth_day
    rename_column :animals, :death_date, :death_day
    add_column :animals, :birth_year, :date
    add_column :animals, :death_year, :date
  end
end
