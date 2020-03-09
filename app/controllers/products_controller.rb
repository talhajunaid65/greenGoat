class ProductsController < ApiController
  before_action :authenticate_user!

  def index
    products = Product.search_available_products(params[:q])

    render json: products, status: :ok
  end

  def show
    product = Product.find(params[:id])

    render json: product, status: :ok
  end
end
