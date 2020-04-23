class GroupItem < ApplicationRecord
  belongs_to :project

  scope :find_by_product_id, -> (prodduct_id) { where(":product_id = ANY(product_ids)", product_id: prodduct_id) }

  before_save :sanitize_array_input

  def sold!
    update(sold: true)
  end

  private

  def sanitize_array_input
    self.product_ids = product_ids.reject(&:blank?)
  end
end
