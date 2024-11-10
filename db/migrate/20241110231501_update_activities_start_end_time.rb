class UpdateActivitiesStartEndTime < ActiveRecord::Migration[7.1]
  def change
    change_column :activities, :start_datetime, :time, null: false
    change_column :activities, :end_datetime, :time, null: false
  end
end
