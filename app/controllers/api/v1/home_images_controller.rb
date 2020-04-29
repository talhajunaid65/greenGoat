class Api::V1::HomeImagesController < ApiController
	def index
	  home_images = HomeImage.all
	  image_array = []
		home_images.each do |home_image|
			image_array << "http://3.84.100.107" + rails_blob_path(home_image.image, only_path: true)
		end
      render json: image_array, status: :ok
	end
end
