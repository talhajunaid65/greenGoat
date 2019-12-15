class ProductSerializer < ActiveModel::Serializer
	include Rails.application.routes.url_helpers
  attributes :id, :title, :room_id,:category,:images, :need_uninstallation, :location, :appraised_value, :price, :description,
			:count, :uom, :width, :height, :depth, :weight, :make, :model,
			:serial, :sale_date, :pickup_date, :uninstallation_date

	def images
		image_array = []
		object.images.each do |image|
			image_array << "http://8f9d3d24.ngrok.io/" + rails_blob_path(image, only_path: true) 
		end

		image_array	
  end

end
