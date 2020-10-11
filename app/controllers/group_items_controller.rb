class GroupItemsController < ApplicationController
  before_action :authenticate_user!

  def show
    @group_item = GroupItem.available.find(params[:id])
    @products = Product.where(id: @group_item.product_ids)
    @product_images = @products.map { |product| product.images if product.images.attached? }

    @simialar_groups = GroupItem.available.first(4)
  end
end
