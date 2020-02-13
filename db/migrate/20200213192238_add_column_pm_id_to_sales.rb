class AddColumnPmIdToSales < ActiveRecord::Migration[5.2]
  def change
    add_column :sales, :pm_id, :integer
  end
end
