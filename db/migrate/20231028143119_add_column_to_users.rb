class AddColumnToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :provider, :string
    rename_column :users, :line_user_id, :uid
  end
end
