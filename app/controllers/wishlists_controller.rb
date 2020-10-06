class WishlistsController < ApplicationController
  before_action :authenticate_user!

  def index
    @wishlists = current_user.wishlists
  end

  def new
    @wishlist = current_user.wishlists.new
  end

  def create
    @wishlist = current_user.wishlists.new(wishlist_params)
    if @wishlist.save
      redirect_to wishlists_path, notice: 'Your have successfully added your wishlist.'
    else
      render :new
    end
  end

  def destroy
    wishlist = current_user.wishlists.find_by_id(params[:id])&.destroy

    redirect_to wishlists_path, notice: 'Your wishlist has been removed.'
  end

  private

  def wishlist_params
    params.require(:wishlist).permit(:name, :description)
  end
end
