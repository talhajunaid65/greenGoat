class AddColumnToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :address, :string
    add_column :products, :city, :string
    add_column :products, :state, :string
    add_column :products, :zipcode, :string
    add_column :products, :wood, :float
    add_column :products, :ceramic, :float
    add_column :products, :glass, :float
    add_column :products, :metal, :float
    add_column :products, :stone_plastic, :float
    add_column :products, :other, :string
    add_column :products, :payment_status, :integer
    add_column :products, :sub_category_id, :integer
    add_reference :products, :category, index: true, foreign_key: true

    remove_column :products, :sold, :boolean
    remove_column :products, :category, :string
    remove_column :products, :weight, :string
    remove_column :products, :location, :string
  end
end
