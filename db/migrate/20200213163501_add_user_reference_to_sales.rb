class AddUserReferenceToSales < ActiveRecord::Migration[5.2]
  def change
    add_reference :sales, :user, index: true
    remove_column :sales, :name, :string
  end
end
