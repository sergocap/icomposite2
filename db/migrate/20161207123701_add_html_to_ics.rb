class AddHtmlToIcs < ActiveRecord::Migration
  def change
    add_column :ics, :html, :text
  end
end
