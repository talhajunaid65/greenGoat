class Api::V1::FavouritesController < ApiController
  before_action :authenticate_user!
  before_action :set_favourite

  def index
    render json: @favourite, status: :ok
  end

  def add_to_favourite
    @favourite.product_ids |= [params[:product_id]]
    @favourite.product_ids = @favourite.product_ids.uniq
    @favourite.save

    render json: @favourite, status: :ok
  end

  def remove_from_favourite
    updated_products = @favourite.product_ids - [params[:product_id].to_s]
    @favourite.product_ids = updated_products
    @favourite.save

    render json: @favourite, status: :ok
  end

  def set_favourite
    @favourite = current_user.favourite || current_user.create_favourite
  end
end
