class CreateComedyTags < ActiveRecord::Migration[7.0]
  def change
    create_table :comedy_tags do |t|
      t.string :name, null: false
      t.timestamps
    end
    add_index :comedy_tags, :name, unique: true
  end
end
