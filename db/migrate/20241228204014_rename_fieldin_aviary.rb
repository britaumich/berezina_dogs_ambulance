class RenameFieldinAviary < ActiveRecord::Migration[8.0]
  def change
    rename_column :aviaries, :sections, :has_sections
  end
end
