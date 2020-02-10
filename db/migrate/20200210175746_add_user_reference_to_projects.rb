class AddUserReferenceToProjects < ActiveRecord::Migration[5.2]
  def change
    add_reference :projects, :user, index: true
    add_foreign_key :projects, :users, on_delete: :cascade
  end
end
