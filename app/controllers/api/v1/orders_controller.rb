class Api::V1::OrdersController < ApiController
  before_action :authenticate_user!
  before_action :ensure_product_or_group

  def create
    result, message = StripeClient.charge(token: order_params[:token], amount: order_params[:amount], email: current_user.email)

    if result
      Order.create(
        price: order_params[:amount],
        item_or_group: order_params[:order_type],
        user_id: current_user.id,
        payment_status: 'Complete',
        item_id: @item.id
      )

      @item.remove_from_group_items if order_params[:order_type] == 'item'
      @item.sold!
    end

    render json: { success: result, message: message }, status: :ok
  end

  private

  def order_params
    params.require(:order).permit(:amount, :order_type, :id, :token)
  end

  def ensure_product_or_group
    @item =
      if order_params[:order_type] == 'item'
        Product.find_by(id: order_params[:id])
      elsif order_params[:order_type] == 'group'
        GroupItem.find_by(id: order_params[:id])
      end

    render json: { success: false, message: "No item or group found with id=#{order_params[:id]}" }, status: 500 if @item.blank?
    render json: { success: false, message: 'This item is already sold' } if @item.sold?
  end

end
