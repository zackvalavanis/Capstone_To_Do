class AddColumnToCategory < ActiveRecord::Migration[7.1]
  def change
    add_column :categories, :activity_id, :integer
  end
end
