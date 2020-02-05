ActiveAdmin.register Project, as: 'Prospect' do
  index do
    selectable_column
    column :name, label: 'Project Name'
    column :type_of_project
    column :start_date
    column :year_built
    column :val_sf
    column :estimated_value
    column :estimated_time
    column :status
    column :pm
    column :appraiser
    column :contractor
    column :architect
    actions do |project|
      link_to 'Go live', edit_admin_contract_path(project), class: 'member_link' unless project.contract?
    end
  end

  form do |f|
    f.inputs do
      f.input :name, label: 'Project Name'
      f.input :type_of_project
      f.input :address
      f.input :city
      f.input :state
      f.input :zip
      f.input :start_date, as: :date_picker
      f.input :year_built
      f.input :val_sf
      f.input :estimated_value
      f.input :status
      f.input :picture, as: :file
      f.input :is_hot
    end
    f.submit value: params[:action] == 'edit' ? 'Update Prospect' : 'Create Prospect'
  end

  action_item :go_live, only: [:show] do
    link_to 'Go live', edit_admin_contract_path(resource) unless resource.contract?
  end

  controller do
    def scoped_collection
      Project.where(status: ['not_pursuing', 'appraisal_notes', 'proposal', nil])
    end

     def update
      update! do |format|
        format.html { redirect_to admin_prospects_path }
      end
    end
  end

  permit_params :name, :type_of_project, :address, :city, :state, :zip, :year_built, :user_id, :status, :tracking_id, :val_sf, :estimated_value, :start_date

end
