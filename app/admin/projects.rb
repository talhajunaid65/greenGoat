ActiveAdmin.register Project, as: 'Project' do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :type_of_project, :address, :city, :state, :zip, :year_built,
			  :user_id, :status, :tracking_id, :val_sf, :estimated_value,
			  :start_date,
			  tasks_attributes: [:id, :job_number, :can_be_sold, :completed, :estimated_time,
			  									 :start_time, :end_time, :_destroy],
			  group_items_attributes: [:id, :title, :price, :description, :project_id, :_destroy, :product_ids => [] ]									 

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

	    f.has_many :group_items, :allow_destroy => true, heading: 'Group Items' do |a|
	        a.input :title
	        a.input :description
	        a.input :price
	        a.input :product_ids, as: :select2_multiple, collection: project.products.all.map {|u| [u.title, u.id]} 
	        a.input :project_id, :input_html => { :value => project.id }, as: :hidden
	    end  
	end    
    f.submit
  end

  show do
	attributes_table(*resource.attributes.keys) do
	    panel "Tasks" do
		  	table_for project.tasks do
		      column :job_number
		      column :completed
		      column :estimated_time
		      column :start_time
		      column :end_time
		    end
		 end  
	 

		panel "Items" do
		  	table_for project.products do
		      column :title
		      column :link do |p| link_to "View", admin_product_path(p) end
		    end
		end 

		panel "Group Items" do
		  	table_for project.group_items do
		      column :title
		      column :price
		      column :products do |p| Product.where(id: project.product_ids).pluck(:title) end
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
