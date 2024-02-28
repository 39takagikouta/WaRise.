class AddIsRecommendedToAlarms < ActiveRecord::Migration[7.0]
  def change
    add_column :alarms, :is_recommended_on_line, :boolean, default: false
  end
end
