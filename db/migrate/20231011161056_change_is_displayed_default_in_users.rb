class ChangeIsDisplayedDefaultInUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :is_displayed, from: nil, to: true
  end
end
