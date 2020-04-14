ActiveAdmin.register Favourite do
  actions :index, :show, :destroy

  index do
    selectable_column
    column :id
    column :product_ids
    column :product_names
    column :user
    actions
  end
end
