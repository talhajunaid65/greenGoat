class ProductStatus < ApplicationRecord
  belongs_to :product
  belongs_to :admin_user

  STATUSES = {
    'available' => 0,
    'listed_for_sale' => 1,
    'has_interest' => 2,
    'scheduled_buyer_meeting' => 3,
    'declined / waiting for other prospects' => 4,
    'took_deposit' => 5,
    'sold' => 6,
    'uninstalled / ready for pickup' => 7,
    'returned / broken' => 8
  }.freeze

  enum new_status: STATUSES

  validates :product_id, :admin_user_id, :new_status, presence: true
end
