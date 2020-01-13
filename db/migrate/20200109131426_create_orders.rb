class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.float :price
      t.string :item_or_group
      t.belongs_to :user
      t.integer :item_id
      t.string :payment_status

      t.timestamps
    end
  end
end
