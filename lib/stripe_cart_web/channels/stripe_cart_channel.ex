defmodule StripeCartWeb.StripeCartChannel do
  use LiveState.Channel, web_module: StripeCartWeb

  alias StripeCart.Cart

  def init(_channel, _payload, _socket) do
    {:ok, %{}}
  end

  def handle_event("add_cart_item", %{"stripe_price" => stripe_price}, %{cart: cart}) do
    {:noreply, %{cart: Cart.add_item(cart, stripe_price)}}
  end

  def handle_event("add_cart_item", %{"stripe_price" => stripe_price}) do
    {:noreply, %{cart: Cart.add_item(stripe_price)}}
  end
end
