class AddColumsToTasks < ActiveRecord::Migration[5.2]
  def up
    add_column :tasks, :title, :string
    add_column :tasks, :description, :text

    change_column :tasks, :job_number, :string
  end

  def down
    remove_column :tasks, :title, :string
    remove_column :tasks, :description, :text

    change_column :tasks, :job_number, "integer USING CAST(job_number AS integer)"
  end
end
