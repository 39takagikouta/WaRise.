class ChangeDefaultOfIsAutomaticallyPostedInUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :is_automatically_posted, true
  end
end
