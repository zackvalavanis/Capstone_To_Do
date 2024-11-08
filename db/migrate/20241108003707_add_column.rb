class AddColumn < ActiveRecord::Migration[7.1]
    def change
      # Add the new datetime columns
      add_column :activities, :start_datetime, :datetime
      add_column :activities, :end_datetime, :datetime
  
      # Remove the old time columns
      remove_column :activities, :time_start, :time
      remove_column :activities, :time_end, :time
    end
end
