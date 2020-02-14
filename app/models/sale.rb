class Sale < ApplicationRecord
  belongs_to :product
  belongs_to :user
  belongs_to :pm, class_name: 'AdminUser', foreign_key: 'pm_id'

  enum payment_method: %i[cash check credit_card]
  enum sale_source: {
    'FB' => 0,
    'CL' => 1,
    'gG' => 2,
    'Cross Sell' => 3,
    'other' => 4
  }
  enum pickup_status: %i[pending delivered]

  validates :product_id, :user_id, presence: true

  delegate :status, to: :product, prefix: true, allow_nil: true

  scope :visits_due, -> { where(visit_date: Date.today) }
  scope :waiting_delivery, -> { where(pickup_status: 'pending') }
  scope :delivered, -> { where(pickup_status: 'pending') }

  validates :pickup_status, :delivery_address, :city, :state, :zipcode, :delivery_cost, :delivery_date, presence: true, if: :need_delivery?

  def to_s
    user
  end
end
