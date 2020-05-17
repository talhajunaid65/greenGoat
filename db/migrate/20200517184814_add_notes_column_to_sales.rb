class AddNotesColumnToSales < ActiveRecord::Migration[5.2]
  def change
    add_column :sales, :notes, :text
  end
end
