class ProductSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :title, :room_id, :category, :sub_category, :images, :need_uninstallation, :appraised_value, :price, :description,
             :count, :uom, :width, :height, :depth, :weight, :make, :model, :address, :city, :state, :zipcode, :price,
             :serial, :sale_date, :pickup_date, :uninstallation_date, :wood, :ceramic, :glass, :metal, :stone_plastic, :asking_price,
             :adjusted_price, :other, :status

  def images
    image_array = []
    object.images.each do |image|
      image_array << Rails.application.credentials.root_url + rails_blob_path(image, only_path: true)
    end

    image_array
  end

  def category
    object.category.to_s
  end

  def sub_category
    object.sub_category.to_s
  end

  def price
    object.sale_price
  end
end
