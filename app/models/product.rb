class Product < ApplicationRecord
  has_many_attached :images

  belongs_to :project
  belongs_to :category
  belongs_to :sub_category, class_name: 'Category', foreign_key: 'sub_category_id'

  has_many :buyers, dependent: :destroy

  enum status: {
    'available' => 0,
    'listed_for_sale' => 1,
    'has_interest' => 2,
    'scheduled_buyer_meeting' => 3,
    'declined / waiting for other prospects' => 4,
    'took_deposit' => 5,
    'sold' => 6,
    'uninstalled / ready for pickup' => 7,
    'returned / broken' => 8
  }

  enum payment_status: [:pending, :received]

  accepts_nested_attributes_for :buyers, allow_destroy: true
end
