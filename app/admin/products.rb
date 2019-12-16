ActiveAdmin.register Product do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :title, :room_id,:category, :need_uninstallation, :location, :appraised_value, :price, :description,
							:count, :uom, :width, :height, :depth, :weight, :make, :model,
							:serial, :sale_date, :pickup_date, :uninstallation_date, images: []
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :image
#   permitted
# end

	form do |f|
    f.inputs
    input :images, as: :file, input_html: { multiple: true }
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
