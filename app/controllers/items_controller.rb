class ItemsController < ApplicationController
  def index
    @items = Product.includes(:category).with_attached_images.available
  end
end
