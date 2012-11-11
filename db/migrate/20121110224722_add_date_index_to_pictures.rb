class AddDateIndexToPictures < ActiveRecord::Migration
  def change
    add_index :pictures, :date, unique: true
  end
end
