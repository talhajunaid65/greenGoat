ActiveAdmin.register Task do
  menu false

  actions :show

  show do
    attributes_table(*resource.attributes.keys) do
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
