class AddThumbnailToViewedvideos < ActiveRecord::Migration[7.0]
  def change
    add_column :viewed_videos, :thumbnail_url, :string
  end
end
