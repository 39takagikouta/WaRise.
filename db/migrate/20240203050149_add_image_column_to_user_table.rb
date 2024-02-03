class AddImageColumnToUserTable < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :image, :string
    add_index :users, :image, unique: true
  end
end
