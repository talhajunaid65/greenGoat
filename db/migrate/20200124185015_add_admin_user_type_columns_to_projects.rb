class AddAdminUserTypeColumnsToProjects < ActiveRecord::Migration[5.2]
  def change
    remove_reference :projects, :user, index: true
    add_column :projects, :pm_id, :integer
    add_column :projects, :appraiser_id, :integer
    add_column :projects, :contractor_id, :integer
  end
end
