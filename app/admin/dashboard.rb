ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Recent Prospects" do
          ul do
            Project.where(status: ['not_pursuing', 'appraisal_notes', 'propsal', nil]).last(5).map do |post|
              li link_to("#{post.address} #{post.city} #{post.state} #{post.zip}", admin_prospect_path(post))
            end
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
