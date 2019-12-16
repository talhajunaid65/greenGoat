class WishlistsController < ApiController
	before_action :authenticate_user!

	def index
		wishlist = current_user.wishlist
		if wishlist.present?
			product_ids = wishlist.product_ids

			products = Product.where(id: product_ids)

			render json: wishlist, status: :ok
		else
			render json: {}, status: :ok
		end	

		
	end	

	def add_to_wishlist
		user = User.find_by(email: params[:user_id])

		if user.wishlist.present?
			wishlist = user.wishlist
		else
			wishlist = Wishlist.create(user_id: user.id, product_ids: [])
		end	

		id = params[:product_id]

		wishlist.product_ids |= [id]
		wishlist.product_ids = wishlist.product_ids.uniq
		wishlist.save

		render json: wishlist, status: :ok
	end	


	def remove_from_wishlist
		user = User.find_by(email: params[:user_id])

		wishlist = user.wishlist

		id = params[:product_id]
		updated_products = wishlist.product_ids - [id.to_s]
		
		wishlist.product_ids = updated_products
		wishlist.save

		render json: wishlist, status: :ok
	end	

end
