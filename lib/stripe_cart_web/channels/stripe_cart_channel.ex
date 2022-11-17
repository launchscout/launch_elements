defmodule StripeCartWeb.StripeCartChannel do
  use LiveState.Channel, web_module: StripeCartWeb

  alias StripeCart.Carts
  alias LiveState.Event

  def init("stripe_cart:new", _payload, _socket) do
    {:ok, %{}}
  end

  def init("stripe_cart:" <> cart_id, _payload, _socket) do
    {:ok, %{cart: Carts.get_cart!(cart_id)}}
  end

  def handle_event("add_cart_item", %{"stripe_price" => stripe_price}, %{cart: cart} = state) do
    case Carts.add_item(cart, stripe_price) do
      {:ok, cart} -> {:noreply, Map.put(state, :cart, cart)}
    end
  end

  def handle_event("add_cart_item", %{"stripe_price" => stripe_price}, state) do
    case Carts.add_item(stripe_price) do
      {:ok, cart} ->
        {:reply, %Event{name: "cart_created", detail: %{cart_id: cart.id}},
         Map.put(state, :cart, cart)}
    end
  end

  def handle_event("checkout", %{"return_url" => return_url}, %{cart: cart} = state) do
    case Carts.checkout(return_url, cart) |> IO.inspect() do
      {:ok, %Stripe.Session{url: checkout_url}} ->
        {:reply, %Event{name: "checkout_redirect", detail: %{checkout_url: checkout_url}},
         Map.put(state, :cart, nil)}
    end
  end
end
