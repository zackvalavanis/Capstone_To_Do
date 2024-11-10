class UpdateActivitiesSchema < ActiveRecord::Migration[7.1]

    def change
      # Change 'date' column type to 'date'
      change_column :activities, :date, :date, null: false
  
      # Ensure start_datetime and end_datetime are still datetime
      change_column :activities, :start_datetime, :datetime, null: false
      change_column :activities, :end_datetime, :datetime, null: false
    end
end
