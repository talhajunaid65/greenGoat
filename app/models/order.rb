class Order < ApplicationRecord
	belongs_to :user

  ORDER_TYPE_ITEM = 'item'
  ORDER_TYPE_GROUP = 'group'

  def item
    return if item_or_group.blank?
    return Product.find_by(id: item_id) if item_or_group == ORDER_TYPE_ITEM

    GroupItem.find_by(id: item_id)
  end
end
