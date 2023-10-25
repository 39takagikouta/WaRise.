class AddVideoLengthToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :video_length, :integer, default: 0
  end
end
