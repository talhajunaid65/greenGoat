class AddColumnsToBuyers < ActiveRecord::Migration[5.2]
  def change
    add_column :buyers, :visit_date, :datetime
    add_column :buyers, :payment_method, :integer
    add_column :buyers, :sale_source, :integer
    add_column :buyers, :other_source, :string
    add_column :buyers, :pickup_status, :integer
    add_column :buyers, :need_delivery, :boolean
    add_column :buyers, :delivery_address, :string
    add_column :buyers, :city, :string
    add_column :buyers, :state, :string
    add_column :buyers, :zipcode, :string
    add_column :buyers, :delivery_cost, :float
    add_column :buyers, :delivery_date, :datetime
    add_column :buyers, :sale_price, :float
  end
end
