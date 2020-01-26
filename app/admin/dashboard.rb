ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Recent Projects" do
          Project.includes(:tasks).contract_projects.last(5).each do |project|
            panel "Project name: #{project.name}" do
              head 'Project tasks'
              hr
              ul do
                project.first_three_hot_tasks.each do |task|
                  li task.job_number
                end
                br
                li link_to 'More', admin_project_path(project)
              end
            end
            hr
          end
        end
      end

      column do
        panel "Info" do
          para "Welcome to ActiveAdmin."
        end
      end
    end
  end # content
end
