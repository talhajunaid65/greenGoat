(->
  window.Order or (window.Order = {})

  Order.initStripeForm = ->
    stripePublishableKey = $('body').data('stripeKey');

    stripe = Stripe(stripePublishableKey);
    elements = stripe.elements();

    style = base:
      fontSize: '16px'
      color: '#32325d'
    card = elements.create('card', { style: style });
    card.mount('#card-element');

    form = document.getElementById('payment-form')
    form.addEventListener 'submit', (event) ->
      event.preventDefault()
      stripe.createToken(card).then (result) ->
        if result.error
          # Inform the customer that there was an error.
          errorElement = document.getElementById('card-errors')
          errorElement.textContent = result.error.message
        else
          # Send the token to your server.
          Order.stripeTokenHandler result.token
        return
      return

  Order.stripeTokenHandler = (token) ->
    # Insert the token ID into the form so it gets submitted to the server
    form = document.getElementById('payment-form')
    $('#order_token').val(token.id)

    form.submit()
).call(this)
