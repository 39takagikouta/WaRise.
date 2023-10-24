class RemoveVideoLengthFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :min_video_length, :integer
    remove_column :users, :max_video_length, :integer
  end
end
