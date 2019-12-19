class HomeImagesController < ApplicationController
	def index
	  home_images = HomeImage.all
	  image_array = []
		home_images.each do |home_image|
			image_array << "http://167.172.245.215" + rails_blob_path(home_image.image, only_path: true) 
		end
      render json: image_array, status: :ok
	end	
end
