class Favourite < ApplicationRecord
  belongs_to :user

  scope :find_by_product_id, -> (prodduct_id) { where(":product_id = ANY(product_ids)", product_id: prodduct_id) }

  def product_names
    Product.where(id: product_ids).pluck(:title).join(', ')
  end
end
