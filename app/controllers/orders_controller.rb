class OrdersController < ApiController
	before_action :authenticate_user!
	def checkout
			require 'net/http'
			require 'net/https'
			require 'uri'

			msg_return = ""

	    url = URI("https://fts.cardconnect.com/cardconnect/rest/auth")

			https = Net::HTTP.new(url.host, url.port);
			https.use_ssl = true

			request = Net::HTTP::Post.new(url)
			request["Authorization"] = ["Basic", "Basic Z3JlZW5nb2E6cyFLSnlZQEs3MiNtSjckMzRTZmV3Uw=="]
			request["Content-Type"] = "application/json"
			request.body = "{\"merchid\": \"496335333886\",\"account\": \"#{params[:number]}\",\"expiry\": \"#{params[:expiry]}\",\"amount\": \"#{params[:price]}\",\"currency\": \"USD\",\"name\": \"CC TEST\"}"

			response = https.request(request)
			response_body = JSON.parse(response.read_body)


	    if response_body["respstat"] == "A"
	    	msg_return = "Payment successfull"
	    	Order.create(price: params[:price], item_or_group: params[:item_type], 
	    								user_id: params[:user_id], payment_status: 'Complete', item_id: params[:id])
	    	if params[:item_type] == 'product'
	    		group_items = GroupItem.all

	    		group_items.each do |group|
	    			product_ids = group.product_ids - [params[:id]] if group.product_ids.include? params[:id]
	    			group.update(product_ids: product_ids)
	    		end
	    			
	    		Product.find(params[:id]).update(sold: true)

	    	elsif params[:item_type] == 'group'
	    		GroupItem.find(params[:id]).update(sold: true)	
	    	end
	    		
	    else
	    	msg_return = "Payment failed, please try again"

	    end	

	    render json: { message: msg_return}, status: :ok
	end


end

