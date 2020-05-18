ActiveAdmin.register Sale do
  config.clear_action_items!

  belongs_to :product, optional: true

  filter :product
  filter :user, label: 'Client'
  filter :pm, label: 'Project Manager', as: :select, collection: proc { AdminUser.pms }
  filter :created_at, label: 'Date Range'
  filter :sale_source, as: :select, collection: proc { Sale.sale_sources }
  filter :other_source_cont, as: :string, label: 'Other Source'
  filter :pickup_status, as: :select, collection: proc { Sale.pickup_statuses }

  action_item :revert, only: :show do
    link_to 'Revert Sale', revert_admin_sale_path(resource) unless sale.returned?
  end

  member_action :revert, method: :get do
    resource.returned!
    redirect_to admin_sale_path(resource), notice: "Sale status is changed to #{resource.pickup_status.upcase}"
  end

  index do
    selectable_column
    column :product
    column 'Client' do |sale|
      link_to sale.user, admin_client_path(sale.user) if sale.user.present?
    end
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
    actions do |sale|
      link_to 'Revert Sale', revert_admin_sale_path(sale), class: 'member_link' unless sale.returned?
    end
  end

  form do |f|
    f.inputs do
      f.input :product_id, label: 'Item', as: :select, collection: Product.all, selected: params[:item_id] || f.object&.product_id
      f.inputs do
        f.input :user, label: 'Client'
        li class: 'weight-labels' do
          link_to 'Add new client', new_admin_client_path
        end
      end
      f.input :sale_source
      f.input :sale_price, input_html: { readonly: !current_admin_user.admin? && action_name == 'edit' }
      f.input :other_source
      f.input :payment_method
      f.input :need_delivery
      f.input :delivery_address
      f.input :city
      f.input :state
      f.input :zipcode
      f.input :delivery_cost
      f.input :delivery_date, as: :datepicker
      f.input :notes
      f.input :pickup_status
      f.input :pm_id, as: :hidden, input_html: { value: f.object.pm ? f.object.pm_id : current_admin_user.id } if current_admin_user.project_manager?
    end
    f.actions
  end

  show do
    attributes_table do
      row :product
      row 'Client' do |sale|
        link_to sale.user, admin_client_path(sale.user) if sale.user
      end
      row :status
      row 'Created By' do |sale|
        link_to sale.pm, admin_admin_user_path(sale.pm) if sale.pm
      end
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
      row :notes
    end
  end


  controller do
    def scoped_collection
      params[:item_id].present? ? Sale.where(product_id: params[:item_id]) : Sale.all
    end

    def create
      @resource = Sale.new(permitted_params[:sale].merge(pm_id: current_admin_user.id))
      if @resource.save
        @resource.product.decrement_count!
        redirect_to admin_sale_path(@resource), notice: 'Sale is created successfully.'
      else
        render :edit
      end
    end
  end

  permit_params :product_id, :sale_source, :other_source, :pickup_status, :pm_id, :notes,
                :need_delivery, :delivery_address, :city, :state, :zipcode, :delivery_cost, :delivery_date, :sale_price, :payment_method, :user_id
end
