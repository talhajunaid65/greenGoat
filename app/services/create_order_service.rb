class CreateOrderService
  attr_reader :order_params, :user, :item

  def initialize(order_params, user, item)
    @order_params = order_params
    @user = user
    @item = item
  end

  def create_order
    result, message = StripeClient.charge(
      token: order_params[:token],
      amount: order_params[:amount],
      email: user.email
    )

    if result
      Order.create(
        price: order_params[:amount],
        item_or_group: order_params[:order_type],
        user_id: user.id,
        payment_status: 'Complete',
        item_id: item.id
      )

      if item.is_a?(Product)
        item.remove_from_group_items
        item.decrement_count!
      else
        item.sold!
      end
    end
    [result, message]
  end
end
