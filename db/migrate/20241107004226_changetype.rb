class Changetype < ActiveRecord::Migration[7.1]
  def change
    remove_column :categories, :type, :string
    add_column :categories, :category_type, :string 
  end
end
