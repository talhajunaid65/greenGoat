class Sale < ApplicationRecord
  belongs_to :product, optional: false
  belongs_to :user, optional: false
  belongs_to :pm, class_name: 'AdminUser', foreign_key: 'pm_id'

  enum payment_method: %i[cash check credit_card]
  enum sale_source: {
    'FB' => 0,
    'CL' => 1,
    'marketplace' => 2,
    'cross_Sell' => 3,
    'other' => 4
  }
  enum pickup_status: %i[pending delivered]

  validates_presence_of :pickup_status, :sale_source
  validates_presence_of :sale_price, numericality: { greater_than: 0.0 }
  validate :product_is_not_sold

  delegate :status, to: :product, prefix: true, allow_nil: true

  scope :waiting_delivery, -> { where(pickup_status: 'pending') }

  validates :pickup_status, :delivery_address, :city, :state, :zipcode, :delivery_cost, :delivery_date, presence: true, if: :need_delivery?

  def to_s
    user.to_s
  end

  private

  def product_is_not_sold
    errors.add(:product_id, 'is already sold') if product && product.sold?
  end
end
