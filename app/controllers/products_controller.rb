class ProductsController < ApiController
  before_action :authenticate_user!

  def index
    products = Product.available_products

    render json: products, status: :ok
  end

  def show
    product = Product.find(params[:id])

    render json: product, status: :ok
  end
end
