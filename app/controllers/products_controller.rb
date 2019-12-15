class ProductsController < ApiController
    before_action :authenticate_user!
    def index
    	q = Product.ransack(params[:q])
		  products = q.result(distinct: true)
      
      render json: products, status: :ok
    end

    def show
      product = Product.find(params[:id])

      render json: product, status: :ok
    end
end