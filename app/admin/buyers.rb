ActiveAdmin.register Buyer do
  belongs_to :product, optional: true

  form do |f|
    f.inputs do
      f.input :product_id, label: 'Item', as: :select, collection: Product.available_products
      f.input :name
      f.input :phone
      f.input :status
      f.input :contact_date
      f.input :visit_date
      f.input :sale_source
      f.input :sale_price
      f.input :other_source
      f.input :payment_method
      f.input :pickup_status
      f.input :need_delivery
      f.input :delivery_address
      f.input :city
      f.input :state
      f.input :zipcode
      f.input :delivery_cost
      f.input :delivery_date
    end
    f.actions
  end

  show do
    attributes_table do
      row :product
      row :name
      row :phone
      row :status
      row :contact_date
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
      params[:item_id].present? ? Buyer.where(product_id: params[:item_id]) : Buyer.all
    end
  end

  permit_params :name, :status, :phone, :contact_date, :product_id, :visit_date, :visit_date, :sale_source, :other_source, :pickup_status,
                :need_delivery, :delivery_address, :city, :state, :zipcode, :delivery_cost, :delivery_date, :sale_price, :payment_method
end
