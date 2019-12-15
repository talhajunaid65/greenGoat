ActiveAdmin.register Project, as: 'Project' do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :type_of_project, :address, :city, :state, :zip, :year_built,
			  :user_id, :status, :tracking_id, :val_sf, :estimated_value,
			  :start_date,
			  tasks_attributes: [:id, :job_number, :can_be_sold, :completed, :estimated_time,
			  									 :start_time, :end_time, :_destroy]
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

  form do |f|
    f.inputs
    f.inputs do 
	    f.has_many :tasks, :allow_destroy => true, heading: 'Tasks' do |a|
        a.inputs
      end  
		end    
    f.submit
  end

  show do
	  attributes_table(*resource.attributes.keys) do
	    panel "Tasks" do
		  	table_for project.tasks do
		      column :job_number
		      column :can_be_sold
		      column :completed
		      column :estimated_time
		      column :start_time
		      column :end_time
		    end
		  end  

		end	 
  end
  
  controller do
    def scoped_collection
      Project.where(status: 'contract')
    end
    
    def update
	    update! do |format|
	      format.html { redirect_to admin_projects_path }
	    end
	  end
    
  end

end
