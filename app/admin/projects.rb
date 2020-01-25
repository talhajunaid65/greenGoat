ActiveAdmin.register Project, as: 'Project' do

  index do
    selectable_column
    column :type_of_project
    column :start_date
    column :tracking
    column :year_built
    column :val_sf
    column :estimated_value
    column :estimated_time
    column :status
    column :pm
    column :appraiser
    column :contractor
    column :architect
    actions
  end

  form do |f|
    f.inputs do
      f.input :pm, as: :select, collection: AdminUser.pms
      f.input :appraiser, as: :select, collection: AdminUser.appraisers
      f.input :contractor, as: :select, collection: AdminUser.contractors
      f.input :architect, as: :select, collection: AdminUser.architects
      f.input :type_of_project
      f.input :address
      f.input :city
      f.input :state
      f.input :zip
      f.input :start_date
      f.input :year_built
      f.input :val_sf
      f.input :estimated_value
      f.input :status
      f.input :is_hot
    end
    f.inputs do 
      f.has_many :tasks, heading: 'Tasks' do |a|
        a.inputs
        a.has_many :notes, heading: 'Notes' do |n|
          n.input :message, label: 'note'
          n.input :created_by_id, input_html: { value: current_admin_user.id }, as: :hidden
        end
      end

      f.has_many :group_items, heading: 'Group Items' do |a|
        a.input :title
        a.input :description
        a.input :price
        a.input :product_ids, as: :select2_multiple, collection: project.products.all.map {|u| [u.title, u.id]}
        a.input :sold
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
          column :sold
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

  permit_params :type_of_project, :address, :city, :state, :zip, :year_built,
        :user_id, :status, :tracking_id, :val_sf, :estimated_value, :start_date, :pm_id, :appraiser_id, :contractor_id, :architect_id,
        tasks_attributes: [:id, :job_number, :can_be_sold, :completed, :estimated_time,
                           :start_time, :end_time, :_destroy, notes_attributes: [:id, :message, :craeted_by_id, :_destroy]],
        group_items_attributes: [:id, :title, :price, :description, :project_id, :sold, :_destroy, :product_ids => [] ]
end
