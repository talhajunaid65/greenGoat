class Api::V1::WishlistsController < ApiController
  before_action :authenticate_user!

  def index
    render json: current_user.wishlists, status: :ok
  end

  def create
    wishlist = current_user.wishlists.new(wishlist_params)
    return render_errors(wishlist.errors.full_messages.to_sentence) unless wishlist.save

    render json: wishlist, status: :ok
  end

  def destroy
    wishlist = current_user.wishlists.find_by_id(params[:id])
    return render_errors('Could not delete wishlist') unless wishlist&.destroy

    render json: wishlist, status: :ok
  end

  private

  def wishlist_params
    params.require(:wishlist).permit(:name, :description)
  end
end
