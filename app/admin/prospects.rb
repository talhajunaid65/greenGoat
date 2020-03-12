ActiveAdmin.register Project, as: 'Prospect' do
  index do
    selectable_column
    column :address
    column :city
    column :state
    column :zip
    column :type_of_project
    column :year_built
    column :sqft
    column :estimated_value
    column :status
    actions do |project|
      link_to 'Go live', edit_admin_contract_path(project), class: 'member_link' unless project.contract?
    end
  end

  action_item :schedule_tour, only: [:show] do
    link_to "Schedule tour", schedule_tour_admin_prospect_path(resource)
  end

  member_action :schedule_tour do
    render 'admin/prospects/tour_form'
  end

  member_action :add_schedule, method: :put do
    visit_date = params[:project][:visit_date]

    if visit_date.present?
      resource.update(visit_date: visit_date)
      ProjectMailer.scheduled_tour_user_email(resource).deliver_now
      ProjectMailer.scheduled_tour_admin_email(user: current_admin_user, prospect: resource).deliver_now
      redirect_to admin_prospect_path(resource), notice: 'Tour is scheduled for prospect.'
    else
      resource.errors.add(:visit_date, "can't be blank")
      render 'admin/prospects/tour_form'
    end
  end

  form do |f|
    f.inputs do
      f.input :user, input_html: { disabled: !f.object.new_record?, class: 'select2-dropdown' }
      f.input :name, label: 'Project Name'
      f.input :type_of_project
      f.input :address
      f.input :city
      f.input :state
      f.input :zip
      f.input :start_date, as: :date_picker
      f.input :year_built
      f.input :sqft
      f.input :val_sf
      f.input :estimated_value
      f.input :status, as: :select, collection: Project.statuses.except(:contract).map{|k, _v| [k, k]}, selected: params.dig(:project, :status) || 'proposal'
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
