ActiveAdmin.register Favourite do
  actions :index, :show, :destroy

  index do
    selectable_column
    column :id
    column :products do |favourite|
      favourite.products.map{ |product| link_to product, admin_item_path(product) }.join(', ').html_safe
    end
    column :user
    actions
  end

  controller do
    def scoped_collection
      Favourite.where.not(product_ids: [])
    end
  end
end
