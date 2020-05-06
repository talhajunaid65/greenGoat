class AddRolesColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :role
    add_column :users, :roles, :string, array: true, default: []
  end
end
