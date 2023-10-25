class ChangeDefaultValuesForVideoLengthInUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :min_video_length, 0
    change_column_default :users, :max_video_length, 3600
  end
end
