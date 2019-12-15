class AddProductsToProjects < ActiveRecord::Migration[5.2]
  def change
  	add_reference :products, :project, index: true
  end
end
