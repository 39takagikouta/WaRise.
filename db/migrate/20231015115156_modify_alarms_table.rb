class ModifyAlarmsTable < ActiveRecord::Migration[7.0]
    def change
    remove_column :alarms, :user_id
    add_reference :alarms, :user, foreign_key: true
    remove_column :alarms, :bootcamp_id
    add_reference :alarms, :bootcamp, foreign_key: true
  end
end
