class CreateItemVisits < ActiveRecord::Migration[5.2]
  def change
    create_table :item_visits do |t|
      t.references :product, index: true
      t.references :user, index: true
      t.datetime :visit_date
      t.datetime :contact_date
      t.integer  :admin_user_id

      t.timestamps
    end

    add_foreign_key :item_visits, :products, on_delete: :cascade
    add_foreign_key :item_visits, :users, on_delete: :cascade
  end
end
