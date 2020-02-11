class Product < ApplicationRecord
  has_many_attached :images

  belongs_to :category
  belongs_to :sub_category, class_name: 'Category', foreign_key: 'sub_category_id'

  has_many :buyers, dependent: :destroy
  has_many :project_products, dependent: :destroy
  has_many :projects, through: :project_products
  has_many :product_statuses, dependent: :destroy

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

  validate :project_products_presence

  scope :available_products, ->  { joins(:product_statuses).where.not('product_statuses.new_status = ?', 6).distinct }
  scope :need_uninstallation, -> { includes(:product_statuses).where(need_uninstallation: true) }

  accepts_nested_attributes_for :project_products, allow_destroy: true

  def project_products_presence
    errors.add(:missing_product_projects, "Must have at least one Project assigned") if project_products.blank?
  end

  def product_status
    product_statuses.last.new_status
  end
end
