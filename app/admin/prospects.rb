ActiveAdmin.register Project, as: 'Prospect' do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :type_of_project, :address, :city, :state, :zip, :year_built, :user_id, :status, :tracking_id, :val_sf, :estimated_value, :start_date
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
  controller do
    def scoped_collection
      Project.where(status: ['not_pursuing', 'appraisal_notes', 'propsal', nil])
    end

     def update
	    update! do |format|
	      format.html { redirect_to admin_prospects_path }
	    end
	  end
  end

end
