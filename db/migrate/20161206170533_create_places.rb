class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.integer :x
      t.integer :y
      t.string  :comment
      t.string  :link
      t.attachment :image
      t.belongs_to :ic
    end
    add_index :places, :x
    add_index :places, :y
  end
end
