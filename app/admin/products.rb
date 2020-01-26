ActiveAdmin.register Product do
  permit_params :title, :room_id,:category, :need_uninstallation, :location, :appraised_value, :price, :description,
							:count, :uom, :width, :height, :depth, :weight, :make, :model,
							:serial, :sale_date, :pickup_date, :uninstallation_date, :sold, :project_id , images: []

  member_action :delete_product_image, method: :delete do
   @pic = ActiveStorage::Attachment.find(params[:id])
   @pic.purge_later
   redirect_back(fallback_location: edit_admin_product_path)
  end

	form do |f|
    f.input :project_id, label: 'Project ID ', as: :select, collection: Project.contract_projects
    f.inputs except: ['project']
    input :images, as: :file, input_html: { multiple: true }
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
