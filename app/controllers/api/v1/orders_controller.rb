class Api::V1::OrdersController < ApiController
  before_action :authenticate_user!
  before_action :ensure_product_or_group

  def create
    result, message = CreateOrderService.new(order_params, current_user, @item).create_order

    render json: { success: result, message: message }, status: :ok
  end

  private

  def order_params
    params.require(:order).permit(:amount, :order_type, :id, :token)
  end

  def ensure_product_or_group
    return render json: { success: false, message: "Amount can't be blank." } if order_params[:amount].blank?

    @item =
      if order_params[:order_type] == 'item'
        Product.find_by(id: order_params[:id])
      elsif order_params[:order_type] == 'group'
        GroupItem.find_by(id: order_params[:id])
      end

    return render json: { success: false, message: "No item or group found with id=#{order_params[:id]}" }, status: 301 if @item.blank?
    render json: { success: false, message: 'This item is already sold' } if @item.sold?
  end

end
