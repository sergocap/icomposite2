class CreateIcs < ActiveRecord::Migration
  def change
    create_table :ics do |t|
      t.string  :title
      t.binary  :html
      t.integer :height
      t.integer :width
      t.integer :place_height
      t.integer :place_width
      t.attachment :image
      t.timestamps null: false
    end
  end
end
