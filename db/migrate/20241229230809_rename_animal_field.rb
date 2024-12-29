class RenameAnimalField < ActiveRecord::Migration[8.0]
  def change
    rename_column :animals, :birth_year, :birth_date
    remove_column :animals, :birth_month
  end
end
