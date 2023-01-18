defmodule LaunchCartWeb.LaunchCartChannel do
  use LiveState.Channel, web_module: LaunchCartWeb

  alias LaunchCart.Carts
  alias LaunchCart.Carts.Cart
  alias LaunchCart.Stores.Store
  alias LaunchCart.Stores
  alias LiveState.Event

  def init("launch_cart:" <> store_id, %{"cart_id" => ""}, socket) do
    case Stores.get_store!(store_id) do
      %Store{id: store_id} -> {:ok, %{}, socket |> assign(:store_id, store_id)}
      nil -> {:error, "Store not found"}
    end
  end

  def init("launch_cart:" <> store_id, %{"cart_id" => cart_id}, socket) do
    socket = socket |> assign(:store_id, store_id)

    case Carts.load_cart(cart_id) do
      {:ok, %Cart{status: :checkout_complete}} ->
        push(socket, "checkout_complete", %{})
        {:ok, %{}, socket}

      {:ok, cart} ->
        {:ok, %{cart: cart}, socket}

      {:error, :cart_not_found} ->
        {:ok, %{}, socket}
    end
  end

  def init("launch_cart:" <> store_id, _params, socket),
    do: init("launch_cart:#{store_id}", %{"cart_id" => ""}, socket)

  def handle_event(
        "add_cart_item",
        %{"stripe_price" => stripe_price},
        %{cart: cart} = state,
        _socket
      ) do
    case Carts.add_item(cart, stripe_price) do
      {:ok, cart} -> {:noreply, Map.put(state, :cart, cart)}
    end
  end

  def handle_event(
        "add_cart_item",
        %{"stripe_price" => stripe_price},
        state,
        %{assigns: %{store_id: store_id}}
      ) do
    with {:ok, cart} <- Carts.create_cart(store_id),
         {:ok, cart} <- Carts.add_item(cart, stripe_price) do
      {:reply, %Event{name: "cart_created", detail: %{cart_id: cart.id}},
       Map.put(state, :cart, cart)}
    end
  end

  def handle_event("remove_cart_item", %{"item_id" => item_id}, %{cart: cart} = state, _socket) do
    case Carts.remove_item(cart, item_id) do
      {:ok, cart} -> {:noreply, Map.put(state, :cart, cart)}
    end
  end

  def handle_event("checkout", %{"return_url" => return_url}, %{cart: cart} = state, _socket) do
    case Carts.checkout(return_url, cart) do
      {:ok, %Cart{checkout_session: %{url: checkout_url}} = cart} ->
        {:reply, %Event{name: "checkout_redirect", detail: %{checkout_url: checkout_url}},
         Map.put(state, :cart, cart)}
    end
  end
end
