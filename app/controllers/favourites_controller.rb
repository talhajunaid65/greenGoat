class FavouritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_favourite

  def index
    @items = Product.where(id: @favourite.product_ids).with_attached_images
    @favourites = @favourite.product_ids.map(&:to_i)
  end

  def add_to_favourite
    @favourite.product_ids |= [params[:product_id]]
    @favourite.product_ids = @favourite.product_ids.uniq
    @favourite.save
  end

  def remove_from_favourite
    updated_products = @favourite.product_ids - [params[:product_id].to_s]
    @favourite.product_ids = updated_products
    @favourite.save
  end

  def set_favourite
    @favourite = current_user.ensure_favourite
  end
end
