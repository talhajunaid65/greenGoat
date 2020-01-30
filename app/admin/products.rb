ActiveAdmin.register Product do
  permit_params :title, :room_id, :category_id, :sub_category_id, :need_uninstallation, :address, :city, :state, :zipcode, :appraised_value, :price, :description,
                :count, :uom, :width, :height, :depth, :wood, :ceramic, :glass, :metal, :stone_plastic, :make, :model, :status, :payment_status,
                :serial, :sale_date, :pickup_date, :uninstallation_date, :project_id, :other, images: []

  member_action :delete_product_image, method: :delete do
    @pic = ActiveStorage::Attachment.find(params[:id])
    @pic.purge_later
    redirect_back(fallback_location: edit_admin_product_path)
  end

  form do |f|
    f.inputs do
      f.input :project, label: 'Project ID', as: :select2, collection: Project.contract_projects
      f.input :category, label: 'Category', as: :select2, collection: Category.parent_categories
      f.input :sub_category_id, label: 'Sub Category', as: :select2, collection: Category.sub_categories
      f.input :title
      f.input :description
      f.input :status
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
    if f.object.images.attached?
      ul do
        f.object.images.each do |img|
          li do 
            span image_tag(img, height: '100')
            span link_to "delete", delete_product_image_admin_product_path(img.id), method: :delete,data: { confirm: 'Are you sure?' }
          end  
         end
      end   
    end
    f.submit
  end

  show do
    attributes_table(*resource.attributes.keys) do
      row :images do |ad|
       ul do
        ad.images.each do |img|
          li do 
            image_tag url_for(img), height: '100'
          end
        end
       end
      end
    end
  end
end
