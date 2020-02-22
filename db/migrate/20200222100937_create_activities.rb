class CreateActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :activities do |t|
      t.references :user, index: true
      t.references :project, index: true
      t.references :task, index: true
      t.string :activity_type

      t.timestamps
    end
  end
end
