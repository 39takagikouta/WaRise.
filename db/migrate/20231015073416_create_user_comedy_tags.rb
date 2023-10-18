class CreateUserComedyTags < ActiveRecord::Migration[7.0]
  def change
    create_table :user_comedy_tags do |t|
      t.integer :user_id, null: false
      t.integer :comedy_tag_id, null: false
      t.timestamps
    end

    add_foreign_key :user_comedy_tags, :users
    add_foreign_key :user_comedy_tags, :comedy_tags

    add_index :user_comedy_tags, [:user_id, :comedy_tag_id], unique: true
  end
end
