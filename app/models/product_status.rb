class ProductStatus < ApplicationRecord
  belongs_to :product
  belongs_to :admin_user


  enum new_status: Product::STATUSES

  validates :product_id, :new_status, presence: true
  after_create :update_product_status

  def to_s
    new_status.titleize
  end

  private

  def update_product_status
    product.update_attributes(status: new_status)
  end
end
