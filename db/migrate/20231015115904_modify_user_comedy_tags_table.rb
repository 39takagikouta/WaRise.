class ModifyUserComedyTagsTable < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :user_comedy_tags, :users
    remove_foreign_key :user_comedy_tags, :comedy_tags
    remove_column :user_comedy_tags, :user_id
    add_reference :user_comedy_tags, :user, foreign_key: true
    remove_column :user_comedy_tags, :comedy_tag_id
    add_reference :user_comedy_tags, :comedy_tag, foreign_key: true
    add_index :user_comedy_tags, [:user_id, :comedy_tag_id], unique: true
  end
end
