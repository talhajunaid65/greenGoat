class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_product_or_group, only: %i[new create]

  def new
    @order = Order.new
  end

  def create
    result, message = CreateOrderService.new(order_params, current_user, @item).create_order

    if result
      redirect_to items_path, notice: message
    else
      flash.now[:alert] = message
      render :new
    end
  end

  def my
    @orders = current_user.orders
    @favourites = Product.where(id: current_user.ensure_favourite.product_ids).ids

    @group_items_products = {}
    @orders_items = {}

    @orders.each do |order|
      order_item = @orders_items[order.id] = order.item
      next if order_item.blank?

      @group_items_products[order_item.id] = Product.where(id: order_item.product_ids) if order_item.is_a?(GroupItem)
    end
  end

  private

  def order_params
    params.require(:order).permit(:amount, :order_type, :id, :token)
  end

  def ensure_product_or_group
    order_type = params[:order_type].presence || order_params[:order_type]
    id = params[:id].presence || order_params[:id]

    @item =
      if order_type == 'item'
        Product.find_by(id: id)
      elsif order_type == 'group'
        GroupItem.find_by(id: id)
      end

    redirect_to items_path, alert: 'Please select an item to buy' if @item.blank?
  end
end
