require Protocol
Protocol.derive(Jason.Encoder, Stripe.Product)
defmodule LaunchCart.CartItem do
  @derive Jason.Encoder

  defstruct quantity: 0, product: nil
end
