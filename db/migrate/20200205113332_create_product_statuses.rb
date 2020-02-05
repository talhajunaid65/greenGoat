class CreateProductStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :product_statuses do |t|
      t.references :product, foreign_key: true
      t.string :old_status
      t.integer :new_status
      t.string :change_reason
      t.references :admin_user, foreign_key: true

      t.timestamps
    end
  end
end
