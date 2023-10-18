class CreateBootcamps < ActiveRecord::Migration[7.0]
  def change
    create_table :bootcamps do |t|
      t.datetime :start_day, null: false
      t.string :reward

      t.timestamps
    end
  end
end
