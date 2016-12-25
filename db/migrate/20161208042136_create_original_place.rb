class CreateOriginalPlace < ActiveRecord::Migration
  def change
    create_table :original_places do |t|
      t.attachment :image
      t.belongs_to :ic
      t.integer    :x
      t.integer    :y
    end
    add_index :original_places, :x
    add_index :original_places, :y
  end
end
