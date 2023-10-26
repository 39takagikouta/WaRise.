class AddBoardIdToViewedVideosTable < ActiveRecord::Migration[7.0]
  def change
    add_reference :viewed_videos, :alarm, foreign_key: true
    remove_index :viewed_videos, column: [:user_id, :video_id], unique: true
    add_index :viewed_videos, [:user_id, :alarm_id, :video_id], unique: true
  end
end
