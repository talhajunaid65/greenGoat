ActiveAdmin.register Product, as: 'Item' do
  permit_params :title, :room_id, :category_id, :sub_category_id, :need_uninstallation, :address, :city, :state, :zipcode, :appraised_value, :price, :description,
                :count, :uom, :width, :height, :depth, :wood, :ceramic, :glass, :metal, :stone_plastic, :make, :model, :status, :payment_status,
                :serial, :sale_date, :pickup_date, :uninstallation_date, :project_id, :other,
                images: [], project_products_attributes: %i[id project_id product_id _destroy]

  member_action :delete_product_image, method: :delete do
    @pic = ActiveStorage::Attachment.find(params[:id])
    @pic.purge_later
    redirect_back(fallback_location: edit_admin_item_path)
  end

  index do
    column :title
    column :description
    column :product_status
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
    f.inputs do
      li "* #{f.object.errors.messages[:missing_product_projects].to_sentence}", class: 'inline-errors' if f.object.errors&.messages[:missing_product_projects].present?
      f.input :category, label: 'Category', as: :select2, collection: Category.parent_categories
      f.input :sub_category_id, label: 'Sub Category', as: :select2, collection: Category.sub_categories
      f.input :title
      f.input :description
      f.input :payment_status
      f.input :room_id
      f.input :need_uninstallation
      f.input :address
      f.input :city
      f.input :state
      f.input :zipcode
      f.input :appraised_value
      f.input :price
      f.input :count
      f.input :uom
      f.input :width
      f.input :height
      f.input :depth
      f.input :wood
      f.input :ceramic
      f.input :glass
      f.input :metal
      f.input :stone_plastic
      f.input :other
      f.input :make
      f.input :model
      f.input :serial
      f.input :sale_date, as: :date_picker
      f.input :pickup_date, as: :date_picker
      f.input :uninstallation_date, as: :date_picker
      f.input :images, as: :file, input_html: { multiple: true }
    end
    f.inputs do
      f.object.project_products.build if f.object.project_products.blank?
      f.has_many :project_products, heading: 'Project', new_record: false do |p|
        p.input :project_id, as: :select, collection: Project.contract_projects
        p.input :product_id, as: :hidden, input_html: { value: f.object.id }
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
end
