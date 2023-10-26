class AddIndexToViewedVideos < ActiveRecord::Migration[7.0]
  def change
    add_index :viewed_videos, [:user_id, :video_id], unique: true
  end
end
