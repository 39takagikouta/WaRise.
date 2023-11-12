class AddCommentToAlarms < ActiveRecord::Migration[7.0]
  def change
    add_column :alarms, :comment, :string
  end
end
