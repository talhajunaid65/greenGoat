class StripeClient
  class << self

    def charge(token:, amount:, email:)
      Stripe.api_key = Rails.application.credentials.stripe[:development_key]
      amount = (amount.to_i * 100).to_i

      begin
        stripe_response =
          Stripe::Charge.create(
            amount: amount,
            currency: "usd",
            source: token,
            description: "Charge for #{email}"
          )
        result = true
        message = "Your card is charged with #{amount/100}$."
        if stripe_response['error'].present?
          result = false
          message = stripe_response['error']['message']
        end
        [result, message]
      rescue => ex
        [false, "There was error in processing charge request. #{ex.message.to_s}."]
      end
    end

  end
end
