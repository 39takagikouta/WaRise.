class CreateKeywords < ActiveRecord::Migration[7.0]
  def change
    create_table :keywords do |t|
      t.references :user, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end
    add_index :keywords, [:user_id, :name], unique: true
  end
end
