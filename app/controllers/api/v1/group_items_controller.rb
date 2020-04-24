class Api::V1::GroupItemsController < ApiController
  def index
    products = GroupItem.where(sold: false)

    render json: products, status: :ok
  end

  def show
    product = GroupItem.find(params[:id])

    render json: product, status: :ok
  end
end
