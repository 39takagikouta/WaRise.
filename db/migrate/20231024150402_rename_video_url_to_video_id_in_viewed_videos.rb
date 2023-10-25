class RenameVideoUrlToVideoIdInViewedVideos < ActiveRecord::Migration[7.0]
  def change
    rename_column :viewed_videos, :video_url, :video_id
  end
end
