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
  has_many :item_visits

  STATUSES = {
    available: 0,
    hold: 1,
    returned: 2,
    sold: 3
  }.freeze

  enum status: STATUSES

  enum payment_status: [:pending, :received]

  validates_presence_of :category_id, :title
  validates_presence_of :weight, if: :material_types_present?
  validates_presence_of :count, numericality: { greater_than: 0 }

  validate :images_attached

  before_save :convert_percentage_to_kg, if: :material_or_weight_changed?

  scope :wating_for_uninstallation, -> { where(need_uninstallation: true) }
  scope :search_by_category, -> (category_id) { where(category_id: category_id) }
  scope :search_by_title, -> (title) { where('title ILIKE ?', "%#{title}%") }
  scope :in_price_range, -> (min_price, max_price) { where('(sale_price >= ? AND sale_price <= ?)', min_price, max_price) }
  scope :not_sold, -> { where.not(status: :sold) }
  scope :for_category, -> (category_id) { where(category_id: category_id) }

  def to_s
    title
  end

  def convert_weight_to_percentage(material_weight)
    return 0 if material_weight.blank? || material_weight == 0

    ((material_weight / weight) * 100).round(2)
  end

  def self.search_available_products(q)
    products = available
    return products if q.blank?

    products = products.search_by_category(q[:category_id]) if q[:category_id].present?
    products = products.search_by_title(q[:title]) if q[:title].present?
    products = products.select do |product|
      if product.adjusted_price.to_i > 0
        product.adjusted_price.between?(q[:min_price].to_f, q[:max_price].to_f)
      else
        product.asking_price.to_i > 0 && product.asking_price.between?(q[:min_price].to_f, q[:max_price].to_f)
      end
    end if q[:min_price].present? && q[:max_price].present?
    products
  end

  def remove_from_group_items
    group_items = GroupItem.find_by_product_id(id.to_s)

    group_items.each do |group_item|
      group_item.product_ids.delete(id.to_s)
      group_item.update(product_ids: group_item.product_ids)
    end
  end

  def decrement_count!
    decrement!(:count)
    product_sold! if count.zero?
  end

  def product_sold!
    sold!
    product_statuses.create(new_status: 'sold')
  end

  def increment_count!
    increment!(:count)
  end

  def price
    adjusted_price.zero? ? asking_price : adjusted_price
  end

  private

  def images_attached
    errors.add(:images, 'Please attach alteast one image') unless images.attached?
  end

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
