class CreateNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :notes do |t|
      t.references :task, index: true
      t.integer    :created_by_id, index: true
      t.text :message

      t.timestamps
    end

    add_foreign_key :notes, :tasks, on_delete: :cascade
  end
end
