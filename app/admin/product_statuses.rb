ActiveAdmin.register ProductStatus do
  menu false
  belongs_to :item, class_name: 'Product'

  breadcrumb

  actions :new, :create, :show

  form do |f|
    f.inputs do
      f.input :new_status, as: :select, collection: Product.statuses.except(:sold).map{|val| [val[0], val[0]]}
      f.input :change_reason
      f.input :admin_user_id, as: :hidden, input_html: { value: current_admin_user.id }
    end
    f.actions do
      f.action :submit
      f.action :cancel, label: 'Cancel'
    end
  end

  permit_params :admin_user_id, :product_id, :new_status, :old_status, :change_reason
end
