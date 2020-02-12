class AddColumnClientCodeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :client_code, :string
  end
end
