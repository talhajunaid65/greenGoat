class GroupItemsController < ApplicationController
	def index
    	q = GroupItem.ransack(params[:q])
		  products = q.result(distinct: true)
      
      render json: products, status: :ok
    end

    def show
      product = GroupItem.find(params[:id])

      render json: product, status: :ok
    end
end
