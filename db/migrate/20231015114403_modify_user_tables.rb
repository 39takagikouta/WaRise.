class ModifyUserTables < ActiveRecord::Migration[7.0]
  def change
    change_column_null :users, :is_displayed, false
  end
end
