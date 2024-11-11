class Deletedate < ActiveRecord::Migration[7.1]
  def change
    remove_column :activities, :date
  end
end
