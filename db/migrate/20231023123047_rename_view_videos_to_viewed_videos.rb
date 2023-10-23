class RenameViewVideosToViewedVideos < ActiveRecord::Migration[7.0]
  def change
    rename_table :view_videos, :viewed_videos
  end
end
