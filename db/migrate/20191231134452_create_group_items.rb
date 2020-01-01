class CreateGroupItems < ActiveRecord::Migration[5.2]
  def change
    create_table :group_items do |t|
      t.string :title
      t.string :description
      t.text :product_ids, array: true, default: []
      t.float :price
      t.belongs_to :project
      t.timestamps
    end
  end
end
