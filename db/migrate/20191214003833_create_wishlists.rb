class CreateWishlists < ActiveRecord::Migration[5.2]
  def change
    create_table :wishlists do |t|
      t.text :product_ids, array: true, default: []
      t.belongs_to :user
      t.timestamps
    end
  end
end
