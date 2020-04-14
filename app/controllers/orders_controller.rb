class OrdersController < ApiController
  # before_action :authenticate_user!

  def checkout
    require 'net/http'
    require 'net/https'
    require 'uri'

    msg_return = ""

    url = URI("https://fts.cardconnect.com/cardconnect/rest/auth")

    https = Net::HTTP.new(url.host, url.port);
    https.use_ssl = true

    # request = Net::HTTP::Post.new(url)
    #
    # request["Content-Type"] = "application/json"

    order_params = { merchantid: Rails.application.credentials.card_connect[:merchant_id], account: params[:number], expiry: params[:expiry], amount: params[:price], currency: 'USD', name: 'CC TEST' }

    Net::HTTP.start(url.host, url.port,
      :use_ssl => url.scheme == 'https',
      :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

      request = Net::HTTP::Post.new url.request_uri
      request["Authorization"] = "Basic #{Rails.application.credentials.card_connect[:username]}:#{Rails.application.credentials.card_connect[:password]}"
      request.body = order_params.to_json
      response = http.request request # Net::HTTPResponse object
      byebug
      puts response
      puts response.body
    end

    # response = https.request(request)
    # byebug
    # response_body = JSON.parse(response.read_body)

    # byebug
    # if response_body["respstat"] == "A"
    #   msg_return = "Payment successfull"
    #   Order.create(price: params[:price], item_or_group: params[:item_type],
    #                 user_id: params[:user_id], payment_status: 'Complete', item_id: params[:id])
    #   if params[:item_type] == 'product'
    #     group_items = GroupItem.all

    #     group_items.each do |group|
    #       product_ids = group.product_ids - [params[:id]] if group.product_ids.include? params[:id]
    #       group.update(product_ids: product_ids)
    #     end

    #     Product.find(params[:id]).sold!

    #   elsif params[:item_type] == 'group'
    #     GroupItem.find(params[:id]).update(sold: true)
    #   end

    # else
    #   msg_return = response_body["resptext"]
    # end

    render json: { message: msg_return }, status: :ok
  end


end

