class AddColumnsToTasks < ActiveRecord::Migration[5.2]
  def change
    rename_column :tasks, :completed, :closed
    rename_column :tasks, :start_time, :start_date
    add_column :tasks, :closed_by_id, :integer
    add_column :tasks, :closed_date, :date
    remove_column :tasks, :end_time
  end
end
