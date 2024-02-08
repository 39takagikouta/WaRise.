class AddTitleToViewedvideos < ActiveRecord::Migration[7.0]
  def change
    add_column :viewed_videos, :title, :string
  end
end
