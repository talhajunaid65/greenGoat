class WishlistsController < ApiController
  before_action :authenticate_user!
  before_action :set_user_by_email, except: [:index]

  def index
    wishlist = current_user.wishlist || curretn_user.create_wishlist
    render json: wishlist, status: :ok
  end

  def add_to_wishlist
    wishlist = @user.wishlist || @user.create_wishlist
    wishlist.product_ids |= [params[:product_id]]
    wishlist.product_ids = wishlist.product_ids.uniq
    wishlist.save

    render json: wishlist, status: :ok
  end


  def remove_from_wishlist
    wishlist = @user.wishlist
    updated_products = wishlist.product_ids - [params[:product_id].to_s]
    wishlist.product_ids = updated_products
    wishlist.save

    render json: wishlist, status: :ok
  end

  private

  def set_user_by_email
    user = User.find_by(email: params[:user_id])
  end
end
