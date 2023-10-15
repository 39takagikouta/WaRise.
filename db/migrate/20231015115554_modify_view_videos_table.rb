class ModifyViewVideosTable < ActiveRecord::Migration[7.0]
  def change
    remove_column :view_videos, :user_id
    add_reference :view_videos, :user, foreign_key: true
    add_index :view_videos, [:user_id, :video_url], unique: true
  end
end
