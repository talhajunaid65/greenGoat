class CreateBuyers < ActiveRecord::Migration[5.2]
  def change
    create_table :buyers do |t|
      t.string :name
      t.string :status
      t.string :phone
      t.datetime :contact_date
      t.references :product, foreign_key: true

      t.timestamps
    end
  end
end
