class AddWeightAndPriceColumnsToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :weight, :float, default: 0.0
    add_column :products, :asking_price, :float, default: 0.0
    add_column :products, :adjusted_price, :float, default: 0.0
    add_column :products, :sale_price, :float, default: 0.0

    remove_column :products, :price, :float
  end
end
