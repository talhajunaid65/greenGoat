ActiveAdmin.register Task do
  actions :index, :show, :destroy

  member_action :close, method: :get do
    task = Task.find(params[:id])
    task.update(closed: true, closed_by: current_admin_user, closed_date: Date.current)
    redirect_to admin_task_path(task), notice: 'Successfully closed task'
  end

  show do
    attributes_table do
      row :job_number
      row :closed
      row :project do |task|
        link_to task.project, admin_project_path(task.project)
      end
      row :is_hot
      row :estimated_time
      row :start_date
      row :closed_date
      row :closed_by
      row :description
      panel "Notes" do
        table_for task.notes do
          column :created_by do |note|
            link_to note.created_by, admin_admin_user_path(note.created_by)
          end
          column :message, label: 'text'
        end
      end
    end
  end
end
