class RemoveUniqueIndexFromViewedVideos < ActiveRecord::Migration[7.0]
  def change
    remove_index :viewed_videos, name: "index_viewed_videos_on_user_id_and_video_id"
  end
end
