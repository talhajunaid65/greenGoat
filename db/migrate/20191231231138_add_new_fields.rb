class AddNewFields < ActiveRecord::Migration[5.2]
  def change
  	remove_column :tasks, :can_be_sold
  	add_column :users, :dob, :datetime
  	add_column :tasks, :is_hot, :boolean
  	add_column :projects, :is_hot, :boolean

  end
end
