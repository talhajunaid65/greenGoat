class GroupItemSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id , :title, :description, :product_ids, :products, :price


  def products
    product_ids = object.product_ids
    products = Product.where(id: product_ids)
    products = products.as_json

    products.each do |product|
      image_array = []
      Product.find(product["id"]).images.each do |image|
        image_array << "http://3.84.100.107" + rails_blob_path(image, only_path: true)
      end
      product['id'] = product['id'].to_s
      product['images'] = image_array
    end
    products
  end
end
