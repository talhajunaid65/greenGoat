ActiveAdmin.register Project, as: 'Contract' do
  menu false

  actions :edit, :update

  form do |f|
    f.inputs do
      f.input :contractor, as: :select, collection: AdminUser.contractors
      f.input :architect, as: :select, collection: AdminUser.architects
      f.input :zillow_location
      f.input :contract_date, as: :date_picker
      f.input :access_info
      f.input :status, as: :hidden, input_html: { value:  'contract' }
    end
    f.submit value: 'Create Contract'
  end

  controller do
    def update
      update! do |format|
        format.html { redirect_to admin_project_path(resource) }
      end
    end
  end

  permit_params :contractor_id, :architect_id, :zillow_location_id, :contract_date, :access_info, :status
end
