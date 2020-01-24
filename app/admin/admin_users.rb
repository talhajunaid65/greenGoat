ActiveAdmin.register AdminUser do
  permit_params :first_name, :last_name, :email, :password, :password_confirmation, :role

  index do
    selectable_column
    column :first_name
    column :last_name
    column :email
    column :role
    column :created_at
    actions
  end

  filter :email
  filter :role
  filter :created_at
  filter :first_name_or_last_name_cont, label: 'Search By Name'

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :role
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
