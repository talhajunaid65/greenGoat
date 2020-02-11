class RenameBuyersToSales < ActiveRecord::Migration[5.2]
  def change
    rename_table :buyers, :sales
  end
end
