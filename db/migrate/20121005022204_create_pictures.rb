class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string    :title
      t.date      :date

      t.text    :media
      t.text    :media_link

      t.text    :credit
      t.text    :explanation

      t.timestamps
    end
  end
end
