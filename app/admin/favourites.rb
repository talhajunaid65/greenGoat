ActiveAdmin.register Favourite do
  actions :index, :show, :destroy

  index do
    selectable_column
    column :id
    column :product_names
    column :user
    actions
  end

  controller do
    def scoped_collection
      Favourite.where.not(product_ids: [])
    end
  end
end
