class ProductSerializer < ActiveModel::Serializer
	include Rails.application.routes.url_helpers
  attributes :id, :title, :room_id,:category,:images, :need_uninstallation, :location, :appraised_value, :price, :description,
			:count, :uom, :width, :height, :depth, :weight, :make, :model,
			:serial, :sale_date, :pickup_date, :uninstallation_date

	def images
		image_array = []
		object.images.each do |image|
			image_array << "http://167.172.245.215" + rails_blob_path(image, only_path: true) 
		end

		image_array	
  end

end
