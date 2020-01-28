class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :type, array: true, default: []
      t.string :capacity, array: true, default: []
      t.integer :sub_category_id
      t.integer :parent_category_id
      t.timestamps
    end
  end
end
