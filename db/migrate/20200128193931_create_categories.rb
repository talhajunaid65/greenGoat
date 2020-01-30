class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :name
      t.text :types, default: [], array: true
      t.text :capacities, default: [], array: true
      t.integer :sub_category_id
      t.integer :parent_category_id
      t.timestamps
    end
  end
end
