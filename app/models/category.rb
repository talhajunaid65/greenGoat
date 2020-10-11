class Category < ApplicationRecord
  belongs_to :parent_category, class_name: 'Category', optional: true

  has_many :sub_categories, class_name: 'Category', foreign_key: 'parent_category_id'
  has_many :products

  scope :parent_categories, -> { where(parent_category_id: nil) }
  scope :sub_categories, -> { where.not(parent_category_id: nil) }

  def to_s
    name
  end
end
