class AddSoldToItems < ActiveRecord::Migration[5.2]
  def change
  	add_column :products, :sold, :boolean, default: false
  	add_column :group_items, :sold, :boolean, default: false
  end
end
