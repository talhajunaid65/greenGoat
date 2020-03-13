ActiveAdmin.register Sale do
  belongs_to :product, optional: true

  filter :product
  filter :user, label: 'Client'
  filter :pm
  filter :created_at, label: 'Date Range'
  filter :sale_source, as: :select, collection: proc { Sale.sale_sources }
  filter :other_source_cont, as: :string, label: 'Other Source'
  filter :pickup_status, as: :select, collection: proc { Sale.pickup_statuses }

  index do
    selectable_column
    column :product
    column 'Client' do |sale|
      link_to sale.user, admin_client_path(sale.user) if sale.user.present?
    end
    column :phone
    column :status
    column :contact_date
    column :visit_date
    column :sale_source
    column :sale_price
    column :other_source
    column :payment_method
    column :need_delivery
    column :delivery_address
    column :city
    column :state
    column :zipcode
    column :delivery_cost
    column :delivery_date
    column :pickup_status
    actions
  end

  form do |f|
    f.inputs do
      f.input :product_id, label: 'Item', as: :select, collection: Product.available_products
      f.input :user, label: 'Client'
      f.input :phone
      f.input :contact_date, as: :datepicker
      f.input :visit_date, as: :datepicker
      f.input :sale_source
      f.input :sale_price
      f.input :other_source
      f.input :payment_method
      f.input :need_delivery
      f.input :delivery_address
      f.input :city
      f.input :state
      f.input :zipcode
      f.input :delivery_cost
      f.input :delivery_date, as: :datepicker
      f.input :pickup_status
      f.input :pm_id, as: :hidden, input_html: { value: f.object.pm ? f.object.pm_id : current_admin_user.id } if current_admin_user.pm?
    end
    f.actions
  end

  show do
    attributes_table do
      row :product
      row 'Client' do |sale|
        link_to sale.user, admin_client_path(sale.user) if sale.user
      end
      row :phone
      row :status
      row :contact_date
      row 'Created By' do |sale|
        link_to sale.pm, admin_admin_user_path(sale.pm) if sale.pm
      end
      row :visit_date
      row :sale_source
      row :sale_price
      row :other_source
      row :payment_method
      row :pickup_status
      row :need_delivery
      row :delivery_address
      row :city
      row :state
      row :zipcode
      row :delivery_cost
      row :delivery_date
    end
  end


  controller do
    def scoped_collection
      params[:item_id].present? ? Sale.where(product_id: params[:item_id]) : Sale.all
    end
  end

  permit_params :phone, :contact_date, :product_id, :visit_date, :visit_date, :sale_source, :other_source, :pickup_status, :pm_id,
                :need_delivery, :delivery_address, :city, :state, :zipcode, :delivery_cost, :delivery_date, :sale_price, :payment_method, :user_id
end
