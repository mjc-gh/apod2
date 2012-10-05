class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string    :ident
      t.string    :title

      t.string    :credit
      t.text      :credit_link

      t.text      :image
      t.text      :explanation

      t.timestamps
    end
  end
end
