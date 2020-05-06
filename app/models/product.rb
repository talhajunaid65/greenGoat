class Product < ApplicationRecord
  has_many_attached :images
  before_destroy :remove_images
  before_destroy :remove_from_group_items
  before_destroy :remove_from_favourites

  belongs_to :category
  belongs_to :sub_category, class_name: 'Category', foreign_key: 'sub_category_id'

  has_many :sales, dependent: :destroy
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
    'picked up' => 8,
    'returned / broken' => 9
  }

  enum payment_status: [:pending, :received]

  validates_presence_of :category_id, :title
  validates_presence_of :weight, if: :material_types_present?

  before_save :convert_percentage_to_kg, if: :material_or_weight_changed?

  scope :available_products, ->  { where.not(id: sold_product_ids) }
  scope :sold_products, -> { where(id: sold_product_ids) }
  scope :wating_for_uninstallation, -> { available_products.where(need_uninstallation: true) }
  scope :search_by_category, -> (category_id) { where(category_id: category_id) }
  scope :search_by_title, -> (title) { where('title ILIKE ?', "%#{title}%") }
  scope :in_price_range, -> (min_price, max_price) { where('sale_price >= ? AND sale_price <= ?', min_price, max_price) }
  scope :where_status_is, -> (status) do
    matching_ids = Product.includes(:product_statuses).all.map { |product| product.id if product.product_statuses.last.new_status == status }
    where(id: matching_ids)
  end

  def self.sold_product_ids
    Product.includes(:product_statuses).all.map{ |product| product.id if product.sold? }
  end

  def product_status
    product_statuses.last.new_status
  end

  def sold?
    product_statuses.last&.sold?
  end

  def to_s
    title
  end

  def convert_weight_to_percentage(material_weight)
    return 0 if material_weight.blank? || material_weight == 0

    ((material_weight / weight) * 100).round(2)
  end

  def sold!
    product_statuses.create(new_status: 6)
  end

  def self.search_available_products(q)
    products = available_products
    return products if q.blank?

    products = products.search_by_category(q[:category_id]) if q[:category_id].present?
    products = products.search_by_title(q[:title]) if q[:title].present?
    products = products.in_price_range(q[:min_price], q[:max_price]) if q[:min_price] || q[:max_price]
    products
  end

  def remove_from_group_items
    group_items = GroupItem.find_by_product_id(id.to_s)

    group_items.each do |group_item|
      group_item.product_ids.delete(id.to_s)
      group_item.update(product_ids: group_item.product_ids)
    end
  end

  def self.ransackable_scopes(*)
    %i(where_status_is)
  end

  private

  def material_types_present?
    wood || ceramic || glass || metal || stone_plastic
  end

  def weight_present?
    weight.present?
  end

  def material_or_weight_changed?
    weight_changed? || wood_changed? || ceramic_changed? || glass_changed? || metal_changed? || stone_plastic_changed?
  end

  def convert_percentage_to_kg
    return if weight.blank?

    self.wood = calculate_weight_from_precentage(wood)
    self.ceramic = calculate_weight_from_precentage(ceramic)
    self.glass = calculate_weight_from_precentage(glass)
    self.metal = calculate_weight_from_precentage(metal)
    self.stone_plastic = calculate_weight_from_precentage(stone_plastic)
    self.other = (weight - (wood + ceramic + glass + metal + stone_plastic)).round(2)
  end

  def calculate_weight_from_precentage(material_percentage)
    return 0 if material_percentage.blank? || material_percentage == 0

    (weight * (material_percentage / 100)).round(2)
  end

  def remove_images
    images&.collect(&:purge_later)
  end

  def remove_from_favourites
    favourites = Favourite.find_by_product_id(self.id.to_s)

    favourites.each do |favourite|
      favourite.product_ids.delete(self.id.to_s)
      favourite.update(product_ids: favourite.product_ids)
    end
  end
end
