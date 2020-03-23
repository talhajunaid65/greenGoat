class CreateUserWishlists < ActiveRecord::Migration[5.2]
  def change
    create_table :wishlists do |t|
      t.references :user, index: true
      t.string :name
      t.text :description
      t.boolean :complete, default: false

      t.timestamps
    end

    add_foreign_key :wishlists, :users, on_delete: :cascade
  end
end
