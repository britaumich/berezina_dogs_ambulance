class AddMainPictureBlobIdToAnimals < ActiveRecord::Migration[8.0]
  def change
    add_column :animals, :main_picture_blob_id, :bigint
    add_index :animals, :main_picture_blob_id
  end
end
