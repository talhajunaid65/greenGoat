ActiveAdmin.register Project, as: 'Prospect' do

  index do
    selectable_column
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
    actions
  end

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

  permit_params :type_of_project, :address, :city, :state, :zip, :year_built, :user_id, :status, :tracking_id, :val_sf, :estimated_value, :start_date

end
