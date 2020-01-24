class AddArchitectIdColumnToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :architect_id, :integer
  end
end
