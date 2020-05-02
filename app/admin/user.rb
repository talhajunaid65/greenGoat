ActiveAdmin.register User, as: 'Client' do
  permit_params :client_code, :firstname, :lastname, :phone, :phone_type, :address1, :address2, :city, :state, :zip

  actions :all, except: [:new, :create]

  filter :email_cont, label: 'Email'
  filter :firstname_cont, label: 'First Name'
  filter :lastname_cont, lebel: 'Last Name'
  filter :client_code_cont, as: :string, label: 'Client Code'
  filter :created_at

  index do
    selectable_column
    id_column
    column :email
    column :firstname
    column :lastname
    column :client_code
    column :sign_in_count
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :firstname
      f.input :lastname
      f.input :email
      f.input :phone
      f.input :phone_type
      f.input :address1
      f.input :address2
      f.input :city
      f.input :state
      f.input :zip
    end
    f.actions do
      f.action :submit
      f.action :cancel, label: 'Cancel'
    end
  end

  show do
    attributes_table(*resource.attributes.keys) do
      row :image do |ad|
        if client.image.attached?
          image_tag url_for(ad.image), height: '60'
        end
      end
    end
  end

end
