class ConvertOtherToFloatInProducts < ActiveRecord::Migration[5.2]
  def change
    remove_column :products, :other, :string
    add_column :products, :other, :float, default: 0.0
  end
end
