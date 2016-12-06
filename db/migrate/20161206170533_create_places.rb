class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.integer :x
      t.integer :y
      t.attachment :image
      t.belongs_to :ic
    end
  end
end
