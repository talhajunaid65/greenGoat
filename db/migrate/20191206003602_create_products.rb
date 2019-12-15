class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :title
      t.string :room_id
      t.string :category
      t.boolean :need_uninstallation
      t.string :location
      t.float :appraised_value
      t.float :price
      t.string :description
      t.integer :status
      t.integer :count
      t.string :uom
      t.string :width
      t.string :height
      t.string :depth
      t.string :weight
      t.string :make
      t.string :model
      t.string :serial
      t.datetime :sale_date
      t.datetime :pickup_date
      t.datetime :uninstallation_date

      t.timestamps
    end
  end
end
