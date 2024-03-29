defmodule LaunchCart.Carts do
  alias LaunchCart.Products
  alias LaunchCart.Carts.{Cart, CartItem}
  alias LaunchCart.Stores.Store
  alias LaunchCart.Stores
  alias LaunchCart.StripeAccounts.StripeAccount

  @create_checkout_session Application.compile_env(
                             :launch_cart,
                             :create_checkout_session,
                             &Stripe.Session.create/2
                           )

  @get_checkout_session Application.compile_env(
                          :launch_cart,
                          :get_checkout_session,
                          &Stripe.Session.retrieve/2
                        )

  alias LaunchCart.Repo

  def get_cart!(cart_id), do: Repo.get!(Cart, cart_id) |> preload_cart()

  def get_cart(cart_id) do
    case Ecto.UUID.cast(cart_id) do
      {:ok, id} -> Repo.get(Cart, id) |> preload_cart()
      :error -> nil
    end
  end

  def load_cart(cart_id) do
    case get_cart(cart_id) do
      nil ->
        {:error, :cart_not_found}

      %Cart{status: :checkout_started} = cart ->
        update_checkout_session(cart)

      %Cart{} = cart ->
        {:ok, cart}
    end
  end

  defp update_checkout_session(
         %Cart{
           checkout_session: %{"id" => session_id},
           store: %Store{stripe_account: %StripeAccount{stripe_id: stripe_id}}
         } = cart
       ) do
    case @get_checkout_session.(session_id, connect_account: stripe_id) do
      {:ok, %Stripe.Session{} = session} ->
        Cart.checkout_changeset(cart, session) |> Repo.update()

      {:error, error} ->
        {:error, error}
    end
  end

  def create_cart(store_id) do
    %{store_id: store_id}
    |> Cart.create_changeset()
    |> Repo.insert()
    |> case do
      {:ok, cart} ->
        {:ok, preload_cart(cart)}

      {:error, error} ->
        {:error, error}
    end
  end

  def add_item(
        %Cart{
          store: %Store{stripe_account: %StripeAccount{stripe_id: stripe_id}}
        } = cart,
        price_id
      ) do
    case Products.get_product(price_id, stripe_id) do
      {:ok, product} -> {:ok, add_product(cart, product)}
      {:error, error} -> {:error, error}
    end
  end

  def add_product(
        %Cart{id: cart_id},
        %{id: stripe_price_id, product: product, amount: price}
      ) do
    {:ok, _cart_item} =
      case Repo.get_by(CartItem, stripe_price_id: stripe_price_id, cart_id: cart_id) do
        nil ->
          CartItem.create_changeset(%{
            stripe_price_id: stripe_price_id,
            price: price,
            product: product,
            quantity: 1,
            cart_id: cart_id
          })
          |> Repo.insert()

        %CartItem{quantity: quantity} = cart_item ->
          cart_item |> CartItem.changeset(%{quantity: quantity + 1}) |> Repo.update()
      end

    get_cart!(cart_id)
  end

  def increase_quantity(cart, item_id), do: update_quantity(cart, item_id, &increment/1)
  def decrease_quantity(cart, item_id), do: update_quantity(cart, item_id, &decrement/1)

  def increment(quantity), do: quantity + 1
  def decrement(quantity), do: max(0, quantity - 1)

  def update_quantity(cart, item_id, update_fn) do
    with %CartItem{quantity: quantity} = cart_item <- Repo.get(CartItem, item_id),
         {:ok, _updated_item} <-
           cart_item |> CartItem.changeset(%{quantity: update_fn.(quantity)}) |> Repo.update() do
      {:ok, get_cart!(cart.id)}
    end
  end

  def checkout(return_url, %Cart{items: items, store_id: store_id} = cart) do
    %Store{stripe_account: %StripeAccount{stripe_id: stripe_id}} = Stores.get_store(store_id)

    case @create_checkout_session.(
           %{
             mode: "payment",
             success_url: return_url,
             cancel_url: return_url,
             shipping_address_collection: %{
               allowed_countries: ["US"]
             },
             line_items: Enum.map(items, &build_line_item/1)
           },
           connect_account: stripe_id
         ) do
      {:ok, checkout_session} ->
        Cart.checkout_changeset(cart, checkout_session) |> Repo.update()

      {:error, error} ->
        {:error, error}
    end
  end

  def remove_item(cart, item_id) do
    with item <- Repo.get(CartItem, item_id), {:ok, _} <- Repo.delete(item) do
      {:ok, Repo.reload!(cart) |> preload_cart}
    end
  end

  def list_products() do
    Cachex.keys!(:stripe_products) |> Enum.map(&Cachex.get!(:stripe_products, &1))
  end

  defp build_line_item(%CartItem{
         quantity: quantity,
         stripe_price_id: price
       }),
       do: %{quantity: quantity, price: price}

  defp preload_cart(cart), do: Repo.preload(cart, items: [], store: [:stripe_account])
end
