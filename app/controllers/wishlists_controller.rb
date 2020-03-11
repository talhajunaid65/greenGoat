class WishlistsController < ApiController
  before_action :authenticate_user!

  def index
    wishlist = current_user.wishlist || current_user.create_wishlist
    render json: wishlist, status: :ok
  end

  def add_to_wishlist
    wishlist = current_user.wishlist || current_user.create_wishlist
    wishlist.product_ids |= [params[:product_id]]
    wishlist.product_ids = wishlist.product_ids.uniq
    wishlist.save

    render json: wishlist, status: :ok
  end


  def remove_from_wishlist
    wishlist = current_user.wishlist
    updated_products = wishlist.product_ids - [params[:product_id].to_s]
    wishlist.product_ids = updated_products
    wishlist.save

    render json: wishlist, status: :ok
  end
end
