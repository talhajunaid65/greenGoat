ActiveAdmin.register ItemVisit do
  config.clear_action_items!

  index do
    selectable_column
    column :product, label: 'Item'
    column 'Client' do |item_visit|
      link_to item_visit.user, admin_client_path(item_visit.user)
    end
    column :created_by
    column :contact_date
    column :visit_date
    actions
  end

  form do |f|
    f.inputs do
      f.input :product_id, as: :select, collection: Product.not_sold, selected: params[:product_id], label: 'Item'
      f.input :user, label: 'Client'
      f.input :visit_date, as: :datepicker
      f.input :contact_date, as: :datepicker
      f.input :admin_user_id, as: :hidden, input_html: { value: current_admin_user.id }
    end
    f.actions
  end

  show do
    attributes_table do
      row :product, label: 'Item'
      row 'Client' do |item_visit|
        link_to item_visit.user, admin_client_path(item_visit.user)
      end
      row :created_by
      row :contact_date
      row :visit_date
    end
  end

  controller do
    def scoped_collection
      params[:product_id].present? ? ItemVisit.where(product_id: params[:product_id]) : ItemVisit.all
    end
  end

  permit_params :visit_date, :contact_date, :product_id, :user_id, :admin_user_id
end
