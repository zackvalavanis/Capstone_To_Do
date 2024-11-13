class ChangeDefaultTimeZoneInActivities < ActiveRecord::Migration[7.1]
  def change
    change_column_default :activities, :time_zone, "UTC"
  end
end
