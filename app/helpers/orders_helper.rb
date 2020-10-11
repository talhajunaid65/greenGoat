module OrdersHelper
  def order_amount(item)
    if item.is_a?(Product)
      item.adjusted_price.zero? ? item.asking_price : item.adjusted_price
    elsif item.is_a?(GroupItem)
      item.price
    end
  end
end
