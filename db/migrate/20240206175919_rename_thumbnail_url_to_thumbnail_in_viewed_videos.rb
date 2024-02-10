class RenameThumbnailUrlToThumbnailInViewedVideos < ActiveRecord::Migration[7.0]
  def change
    rename_column :viewed_videos, :thumbnail_url, :thumbnail
  end
end
