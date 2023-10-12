class CreateViewVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :view_videos do |t|
      t.integer :user_id, null: false, foreign_key: true
      t.string :video_url

      t.timestamps
    end
  end
end
