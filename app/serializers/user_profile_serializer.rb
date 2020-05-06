class UserProfileSerializer < ActiveModel::Serializer
	include Rails.application.routes.url_helpers
  attributes :id, :firstname, :lastname, :email, :password, :password_confirmation,
	  		 :phone, :phone_type, :address1, :address2, :city, :state, :zip, :roles,
	  		 :image

	def image
      rails_blob_path(object.image, only_path: true) if object.image.attached?
  end

end
