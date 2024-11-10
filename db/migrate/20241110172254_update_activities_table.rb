class UpdateActivitiesTable < ActiveRecord::Migration[7.1]
  def change
    change_table :activities do |t|
      # Change date to datetime to store both date and time
      t.change :date, :datetime, null: false
      
      # Set default and nullability for finished field
      t.change :finished, :boolean, default: false, null: true

      # Ensure start_datetime and end_datetime are always present
      t.change :start_datetime, :datetime, null: false
      t.change :end_datetime, :datetime, null: false

      # Add time_zone for the user
      t.string :time_zone, default: 'UTC'
  end
end 
end
