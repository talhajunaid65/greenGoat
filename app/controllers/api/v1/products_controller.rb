class Api::V1::ProductsController < ApiController
  before_action :authenticate_user!

  def index
    products = Product.includes(:category).with_attached_images.available.search_available_products(params[:q])

    render json: products, status: :ok
  end

  def show
    product = Product.find(params[:id])

    render json: product, status: :ok
  end

  def categories
    categories = Category.parent_categories.map{ |category| { id: category.id, name: category.name } }

    render json: { categories: categories }, status: :ok
  end
end
