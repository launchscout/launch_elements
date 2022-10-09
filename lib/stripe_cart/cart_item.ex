require Protocol
Protocol.derive(Jason.Encoder, Stripe.Product)
defmodule StripeCart.CartItem do
  @derive Jason.Encoder

  defstruct quantity: 0, product: nil
end
