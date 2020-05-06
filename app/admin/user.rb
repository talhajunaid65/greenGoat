ActiveAdmin.register User, as: 'Client' do
  permit_params :client_code, :firstname, :lastname, :phone, :phone_type, :address1, :address2, :city, :state, :zip, :email, roles: []

  filter :email_cont, label: 'Email'
  filter :firstname_cont, label: 'First Name'
  filter :lastname_cont, label: 'Last Name'
  filter :where_roles_contains, as: :select, collection: proc { User::ROLES.map{|key, value| [value, key.to_s] } }, label: 'Role'
  filter :client_code_cont, as: :string, label: 'Client Code'
  filter :created_at

  index do
    selectable_column
    id_column
    column :email
    column :firstname
    column :lastname
    column :client_code
    column :roles, &:titleize_roles
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
      f.input :roles, as: :select, collection: User::ROLES.map{|key, value| [value, key.to_s] }, class: 'select2-dropdown', multiple: true
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

  controller do
    def create
      @resource = User.new(permitted_params[:user])
      if @resource.email.blank?
        @resource.errors.add(:email, "Can't be blank.")
        return render :new
      end

      @resource.save(validate: false)
      redirect_to admin_client_path(@resource), notice: 'Client created successfully.'
    end
  end
end
