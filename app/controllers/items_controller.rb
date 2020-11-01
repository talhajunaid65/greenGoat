class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: %i[show]
  before_action :set_favourites

  def index
    return redirect_to categories_items_path, alert: 'Please select a category' if params.dig(:q, :category_id).blank?

    @items = Product.includes(:category).with_attached_images.available.search_available_products(params[:q])
    @group_items = GroupItem.where(sold: false)
    @group_items_products = {}
    @group_items.each { |group_item| @group_items_products[group_item.id] = Product.where(id: group_item.product_ids) }
  end

  def show
    @similar_items = Product.includes(:category).with_attached_images.available.for_category(@item.category_id).first(4)
  end

  def categories
    @categories = Category.parent_categories
  end

  private

  def set_product
    @item = Product.find(params[:id])
  end

  def set_favourites
    @favourites = current_user.ensure_favourite.product_ids.map(&:to_i)
  end
end
