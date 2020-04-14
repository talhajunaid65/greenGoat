CardConnect.configure do |config|
  config.merchant_id = Rails.application.credentials.card_connect[:merchant_id]
  config.api_username = Rails.application.credentials.card_connect[:username]
  config.api_password = Rails.application.credentials.card_connect[:password]
  config.endpoint = 'https://fts.cardconnect.com:6443'
end
