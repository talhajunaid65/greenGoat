ActiveAdmin.register Project, as: 'Project' do

  index do
    selectable_column
    column :name
    column :type_of_project
    column :start_date
    column :tracking
    column :year_built
    column :val_sf
    column :estimated_value
    column :estimated_time
    column :status
    column :'pm' do |project|
      link_to project.pm, admin_admin_user_path(project.pm) if project.pm
    end
    column :appraiser do |project|
      link_to project.appraiser, admin_admin_user_path(project.appraiser) if project.appraiser
    end
    column :contractor do |project|
      link_to project.contractor, admin_admin_user_path(project.contractor) if project.contractor
    end
    column :architect do |project|
      link_to project.architect, admin_admin_user_path(project.architect) if project.architect
    end
    actions
  end

  form do |f|
    f.inputs do
      f.input :pm, as: :select, collection: AdminUser.pms
      f.input :appraiser, as: :select, collection: AdminUser.appraisers
      f.input :contractor, as: :select, collection: AdminUser.contractors
      f.input :architect, as: :select, collection: AdminUser.architects
      f.input :name, label: 'Project Name'
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
      f.input :picture, as: :file
      f.input :is_hot
    end
    f.inputs do 
      f.has_many :tasks, heading: 'Tasks' do |a|
        a.inputs do
          a.input :job_number
          a.input :estimated_time
          a.input :start_time
          a.input :end_time
          a.input :is_hot
          a.input :completed
          a.has_many :notes, heading: 'Notes' do |n|
            n.input :message, label: 'note', input_html: { readonly: n.object.created_by && (n.object.created_by != current_admin_user)  }
            if n.object.new_record? || (n.object.created_by == current_admin_user)
              n.input :created_by_id, input_html: { value: current_admin_user.id }, as: :hidden
              n.input :_destroy, as: :boolean, required: false, label: 'Delete note'
            end
          end
          a.input :_destroy, as: :boolean, required: false, label: 'Delete task'
        end
      end

      f.has_many :group_items, heading: 'Group Items' do |a|
        a.input :title
        a.input :description
        a.input :price
        a.input :product_ids, as: :select2_multiple, collection: project.products.all.map {|u| [u.title, u.id]}
        a.input :sold
        a.input :project_id, :input_html => { :value => project.id }, as: :hidden
        a.input :_destroy, as: :boolean, required: false, label: 'Delete Group Item'
      end
    end
    f.submit
  end

  show do
    attributes_table do
      row :picture do |project|
        project.picture.attached? ? image_tag(project.picture, size: '80x80') : 'Picture not attached'
      end
      row :project_name do |project|
        project.name
      end
      row :type_of_project
      row :address
      row :city
      row :state
      row :zip
      row :start_date
      row :year_built
      row :val_sf
      row :estimated_value
      row :status
      row :is_hot
      panel "Tasks" do
        table_for project.tasks do
          column :job_number
          column :completed
          column :estimated_time
          column :start_time
          column :end_time
          column 'Notes' do |task|
            link_to "Notes", admin_task_path(task)
          end
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
      return Project.contract_projects if current_admin_user.admin?
      admin_id = current_admin_user.id
      return Project.contract_projects.pm_projects(admin_id) if current_admin_user.pm?
      return Project.contract_projects.contractor_projects(admin_id) if current_admin_user.contractor?
      return Project.contract_projects.appraiser_projects(admin_id) if current_admin_user.appraiser?
      Project.contract_projects.architect_projects(admin_id) if current_admin_user.architect?
    end
    
    def update
      update! do |format|
        format.html { redirect_to admin_projects_path }
      end
    end
    
  end

  permit_params :name, :type_of_project, :address, :city, :state, :zip, :year_built, :picture,
        :user_id, :status, :tracking_id, :val_sf, :estimated_value, :start_date, :pm_id, :appraiser_id, :contractor_id, :architect_id,
        tasks_attributes: [:id, :job_number, :can_be_sold, :completed, :estimated_time,
                           :start_time, :end_time, :_destroy, notes_attributes: [:id, :message, :created_by_id, :_destroy]],
        group_items_attributes: [:id, :title, :price, :description, :project_id, :sold, :_destroy, :product_ids => [] ]
end
