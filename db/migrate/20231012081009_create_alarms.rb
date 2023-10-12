class CreateAlarms < ActiveRecord::Migration[7.0]
  def change
    create_table :alarms do |t|
      t.integer :user_id, null: false, foreign_key: true
      t.integer :bootcamp_id, foreign_key: true
      t.datetime :wake_up_time, null: false
      t.string :custom_video_url
      t.boolean :is_successful
      t.string :factor
      t.datetime :sleep_start_time
      t.datetime :sleep_end_time

      t.timestamps
    end
  end
end
