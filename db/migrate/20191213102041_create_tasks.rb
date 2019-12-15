class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.integer :job_number
      t.boolean :can_be_sold
      t.boolean :completed
      t.string :estimated_time
      t.datetime :start_time
      t.datetime :end_time

      t.belongs_to :project

      t.timestamps
    end
  end
end
