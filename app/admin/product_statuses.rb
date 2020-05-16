ActiveAdmin.register ProductStatus do
  menu false
  belongs_to :item, class_name: 'Product'

  breadcrumb

  actions :new, :create

  form do |f|
    f.inputs do
      f.input :new_status, as: :select, collection: Product.statuses.map{ |val| [val[0], val[0]] }, selected: f.object.product.status
      f.input :change_reason
    end
    f.actions do
      f.action :submit
      f.action :cancel, label: 'Cancel'
    end
  end

  controller do
    def create
      @resource = ProductStatus.new(permitted_params[:product_status].merge(admin_user: current_admin_user, product_id: permitted_params[:item_id]))
      if (@resource.sold? || @resource.product.returned?) && !current_admin_user.admin?
        redirect_to new_admin_item_product_status_path(item_id: permitted_params[:item_id], product_id: permitted_params[:item_id]),
                          alert: 'Only super admin can mark this status.'
        return
      end

      if @resource.save
        redirect_to admin_item_path(id: @resource.product.id, product_id: @resource.product.id), notice: "Product status is changed to #{@resource.new_status.upcase}"
      else
        redirect_to new_admin_item_product_status_path(item_id: permitted_params[:item_id], product_id: permitted_params[:item_id]),
                    alert: @resource.errors.full_messages.to_sentence
      end
    end
  end

  permit_params :product_id, :new_status, :change_reason
end
