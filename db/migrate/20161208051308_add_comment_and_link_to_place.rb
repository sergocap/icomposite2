class AddCommentAndLinkToPlace < ActiveRecord::Migration
  def change
    add_column :places, :comment, :string
    add_column :places, :link, :string
  end
end
