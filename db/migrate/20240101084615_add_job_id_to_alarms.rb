class AddJobIdToAlarms < ActiveRecord::Migration[7.0]
  def change
    add_column :alarms, :job_id, :string
    add_index :alarms, :job_id, unique: true
  end
end
