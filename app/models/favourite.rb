class Favourite < ApplicationRecord
  belongs_to :user

  scope :find_by_product_id, -> (prodduct_id) { where(":product_id = ANY(product_ids)", product_id: prodduct_id) }
end
