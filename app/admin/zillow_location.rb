ActiveAdmin.register ZillowLocation do
  permit_params :type_of_project, :address, :city, :state, :zip, :year_built, :user_id, :tracking_id, :val_sf,
                :estimated_value, :start_date

  form do |f|
    f.inputs do
      f.input :user
      f.input :type_of_project
      f.input :address
      f.input :city
      f.input :state
      f.input :zip
      f.input :start_date, as: :datepicker
      f.input :year_built
      f.input :val_sf
      f.input :estimated_value
      f.input :latitude
      f.input :longitude
    end
    f.actions
  end
end
