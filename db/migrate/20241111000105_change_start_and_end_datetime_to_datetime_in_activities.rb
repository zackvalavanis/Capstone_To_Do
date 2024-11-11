class ChangeStartAndEndDatetimeToDatetimeInActivities < ActiveRecord::Migration[6.0]
  def up
    # First, let's clean up the start_datetime and end_datetime by setting a default date (today's date)
    Activity.find_each do |activity|
      next if activity.start_datetime.nil? || activity.end_datetime.nil?

      start_time = activity.start_datetime
      end_time = activity.end_datetime

      # Use today's date, and preserve the time portion from the existing data
      today = Date.today

      # Update start_datetime and end_datetime to include today's date
      activity.update_columns(
        start_datetime: today.to_time.change(hour: start_time.hour, min: start_time.min, sec: start_time.sec),
        end_datetime: today.to_time.change(hour: end_time.hour, min: end_time.min, sec: end_time.sec)
      )
    end

    # Alter column type from 'time' to 'timestamp'
    # Using the 'USING' clause ensures correct casting
    execute <<-SQL
      ALTER TABLE activities
      ALTER COLUMN start_datetime SET DATA TYPE timestamp WITHOUT TIME ZONE
      USING (start_datetime::text || ' ' || '#{Date.today}')::timestamp;

      ALTER TABLE activities
      ALTER COLUMN end_datetime SET DATA TYPE timestamp WITHOUT TIME ZONE
      USING (end_datetime::text || ' ' || '#{Date.today}')::timestamp;
    SQL
  end

  def down
    # Revert columns back to 'time' type if rolling back
    execute <<-SQL
      ALTER TABLE activities
      ALTER COLUMN start_datetime SET DATA TYPE time WITHOUT TIME ZONE
      USING start_datetime::time;

      ALTER TABLE activities
      ALTER COLUMN end_datetime SET DATA TYPE time WITHOUT TIME ZONE
      USING end_datetime::time;
    SQL
  end
end
