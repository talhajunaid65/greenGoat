class Buyer < ApplicationRecord
  belongs_to :product

  enum payment_method: %i[cash check credit_card]
  enum sale_source: {
    'FB' => 0,
    'CL' => 1,
    'gG' => 2,
    'Cross Sell' => 3,
    'other' => 4
  }
  enum pickup_status: %i[pending delivered]

  validates :product_id, :name, presence: true

  delegate :status, to: :product, prefix: true
end
