ActiveAdmin.register Product, as: 'Item' do

  filter :title_cont, as: :string, label: 'Title'
  filter :category, input_html: { class: 'select2-dropdown' }
  filter :product_statuses_new_status_eq, as: :select, collection: proc { ProductStatus.new_statuses }, label: 'Status', input_html: { class: 'select2-dropdown' }
  filter :need_uninstallation
  filter :uninstallation_date
  filter :asking_price_eq, label: 'Asking Price'
  filter :sale_price_eq, label: 'Sale Price'
  filter :model_cont, label: 'Model'
  filter :serial_cont, label: 'Serial'
  filter :make_cont, label: 'Make'

  scope 'Items Waiting For Uninstallation', :wating_for_uninstallation
  scope 'Show All Available', :available_products

  member_action :delete_product_image, method: :delete do
    @pic = ActiveStorage::Attachment.find(params[:id])
    @pic.purge_later
    redirect_back(fallback_location: edit_admin_item_path)
  end

  collection_action :filter_sub_categories, method: :get do
    @sub_categories = Category.where(parent_category_id: params[:category_id])

   respond_to do |format|
      format.js
    end
  end

  index do
    column :title
    column :description
    column 'Status', &:product_status
    column :category
    column :sub_category
    column :appraised_value
    column :price
    column :uom
    actions do |item|
      link_to 'Change Status', new_admin_item_product_status_path(item_id: item.id, product_id: item.id), class: 'member_link'
    end
  end

  form do |f|
    f.inputs name: 'Basic' do
      f.input :category, label: 'Category', as: :select, collection: Category.parent_categories, input_html: { class: 'select2-dropdown' }
      f.input :sub_category, label: 'Sub Category', as: :select, collection: Category.sub_categories, input_html: { class: 'select2-dropdown' }
      f.input :make
      f.input :model
      f.input :serial
      f.input :title
      f.input :description
      f.input :count
      f.input :width
      f.input :height
      f.input :depth
      f.input :room_id
      f.input :uom
      f.input :payment_status
      f.input :need_uninstallation
      f.input :uninstallation_date, as: :date_picker
      f.input :images, as: :file, input_html: { multiple: true }
    end
    f.inputs name: 'Location' do
      f.input :address
      f.input :city
      f.input :state
      f.input :zipcode
    end
    f.inputs name: 'Price' do
      f.input :appraised_value, label: 'Appraisal'
      f.input :asking_price
      f.input :adjusted_price
      f.input :sale_price
    end
    f.inputs name: 'Weight Estimation 'do
      f.input :weight, label: 'Weight (Kg)'
      f.inputs do
        f.input :wood, label: 'Wood (%)', input_html: { value: f.object.convert_weight_to_percentage(f.object.wood), data: { type: 'wood' } }
        li "Weight in kg: #{f.object.wood}", id: 'wood_weight_in_kg', class: 'weight-labels'
      end
      f.inputs do
        f.input :ceramic, label: 'Ceramic (%)', input_html: { value: f.object.convert_weight_to_percentage(f.object.ceramic), data: { type: 'ceramic' } }
        li "Weight in kg: #{f.object.ceramic}", id: 'ceramic_weight_in_kg', class: 'weight-labels'
      end
      f.inputs do
        f.input :glass, label: 'Glass (%)', input_html: { value: f.object.convert_weight_to_percentage(f.object.glass), data: { type: 'glass' } }
        li "Weight in kg: #{f.object.glass}", id: 'glass_weight_in_kg', class: 'weight-labels'
      end
      f.inputs do
        f.input :metal, label: 'Metal (%)', input_html: { value: f.object.convert_weight_to_percentage(f.object.metal), data: { type: 'metal' } }
        li "Weight in kg: #{f.object.metal}", id: 'metal_weight_in_kg', class: 'weight-labels'
      end
      f.inputs do
        f.input :stone_plastic, label: 'Stone Plastic (%)', input_html: { value: f.object.convert_weight_to_percentage(f.object.stone_plastic), data: { type: 'stone_plastic' } }
        li "Weight in kg: #{f.object.stone_plastic}", id: 'stone_plastic_weight_in_kg', class: 'weight-labels'
      end
      f.input :other, label: 'Other (Kg)', input_html: { readonly: true }
    end
    f.inputs name: '' do
      f.input :sale_date, as: :date_picker
      f.input :pickup_date, as: :date_picker
    end
    f.inputs name: '' do
      f.has_many :project_products, heading: 'Project', new_record: false,  allow_destroy: false do |p|
        p.input :project, as: :select, collection: Project.contract_projects, input_html: { disabled: !f.object.new_record? }
      end
    end
    if f.object.images.attached?
      ul do
        f.object.images.each do |img|
          li do
            span image_tag(img, height: '100')
            span link_to "delete", delete_product_image_admin_item_path(img.id), method: :delete,data: { confirm: 'Are you sure?' }
          end
         end
      end
    end
    f.submit value: params[:action] == 'edit' ? 'Update Item' : 'Create Item',
             data: { disable_with: params[:action] == 'edit' ? 'Update Item' : 'Create Item' }
  end

  show do
    attributes_table do
      row :category
      row :sub_category_id
      row :title
      row :description
      row :payment_status
      row 'Status' do |item|
        item.product_status
      end
      row :room_id
      row :need_uninstallation
      row :address
      row :city
      row :state
      row :zipcode
      row :appraised_value
      row :price
      row :count
      row :uom
      row :width
      row :height
      row :depth
      row :wood
      row :ceramic
      row :glass
      row :metal
      row :stone_plastic
      row :other
      row :make
      row :model
      row :serial
      row :sale_date
      row :pickup_date
      row :uninstallation_date
      row :images do |ad|
        ul do
          ad.images.each do |img|
            li do
              image_tag url_for(img), height: '100'
            end
          end
        end
      end
      panel 'Changed Status' do
        table_for item.product_statuses do
          column :new_status
          column 'Changed By' do |status|
            link_to status.admin_user, admin_admin_user_path(status.admin_user)
          end
          column :change_reason
          column "Changed at" do |status|
            status.created_at
          end
        end
      end

      panel "Projects" do
        table_for item.projects do
          column "Name" do |project|
            link_to project.name, admin_project_path(project)
          end
          column :type_of_project
        end
      end

      panel "Sales" do
        table_for item.sales do
          column "Buyer Name" do |sale|
            link_to sale, admin_sale_path(sale)
          end
          column :phone
          column :contact_date
          column do |sale|
            link_to "Add Sale", new_admin_item_sale_path(item)
          end
        end
      end
    end
  end

  controller do
    def scoped_collection
      Product.available_products
    end

    def create
      create! do |a|
        resource.product_statuses.create(new_status: 0, admin_user_id: current_admin_user.id) unless resource.errors.any?
      end
    end
  end

  permit_params :title, :room_id, :category_id, :sub_category_id, :need_uninstallation, :address, :city, :state, :zipcode, :appraised_value, :price, :description, :count, :uom, :width, :height, :depth, :wood, :ceramic, :glass, :metal, :stone_plastic, :make, :model, :status, :payment_status,
                :serial, :sale_date, :pickup_date, :uninstallation_date, :project_id, :other, :weight, :asking_price, :adjusted_price, :sale_price,
                images: [], project_products_attributes: %i[id project_id product_id _destroy]

end
