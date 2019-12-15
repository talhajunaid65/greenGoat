ActiveAdmin.register User do
 permit_params :email, :password, :password_confirmation, :firstname, :lastname,
         :phone, :phone_type, :address1, :address2, :city, :state, :zip

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs 
    f.actions
  end

  show do
    attributes_table(*resource.attributes.keys) do
      row :image do |ad|
          image_tag url_for(ad.image)
        end
    end
  end  

end
