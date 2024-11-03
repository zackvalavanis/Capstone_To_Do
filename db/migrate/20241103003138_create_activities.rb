class CreateActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :activities do |t|
      t.integer :user_id
      t.date :date
      t.time :time_start
      t.time :time_end
      t.boolean :finished

      t.timestamps
    end
  end
end
