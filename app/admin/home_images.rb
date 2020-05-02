ActiveAdmin.register HomeImage do
  config.filters = false
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :image
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
form do |f|
    f.inputs
    input :image, as: :file
    f.submit
  end

	show do
	  attributes_table(*resource.attributes.keys) do
	    row :image do |ad|
	       image_tag url_for(ad.image), height: '200'
	    end
	  end
	end


end
