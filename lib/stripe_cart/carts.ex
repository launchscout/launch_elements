defmodule StripeCart.Carts do
  alias StripeCart.Carts.{Cart, CartItem}
  alias StripeCart.Stores.Store
  alias StripeCart.Stores
  alias StripeCart.StripeAccounts.StripeAccount

  @create_checkout_session Application.get_env(
                             :stripe_cart,
                             :create_checkout_session,
                             &Stripe.Session.create/2
                           )

  @get_checkout_session Application.get_env(
                          :stripe_cart,
                          :get_checkout_session,
                          &Stripe.Session.retrieve/2
                        )

  alias StripeCart.Repo

  def get_cart!(cart_id), do: Repo.get!(Cart, cart_id) |> Repo.preload(:items)

  def load_cart(cart_id) do
    case Repo.get(Cart, cart_id) |> Repo.preload(items: [], store: [:stripe_account]) do
      nil ->
        {:error, :cart_not_found}

      %Cart{status: :checkout_started} = cart ->
        update_checkout_session(cart)

      %Cart{} = cart ->
        {:ok, cart}
    end
  end

  defp update_checkout_session(%Cart{
         checkout_session: %{"id" => session_id},
         store: %Store{stripe_account: %StripeAccount{stripe_id: stripe_id}}
       } = cart) do
    case @get_checkout_session.(session_id, connect_account: stripe_id) do
      {:ok, %Stripe.Session{} = session} ->
        Cart.checkout_changeset(cart, session) |> Repo.update()
      {:error, error} -> {:error, error}
    end
  end

  def create_cart(store_id) do
    %{store_id: store_id} |> Cart.create_changeset() |> Repo.insert()
  end

  def add_item(%Cart{} = cart, price_id) do
    case Cachex.get(:stripe_products, price_id) do
      {:ok, product} -> {:ok, add_product(cart, product)}
      _ -> {:error, "Product not found"}
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

    Repo.get(Cart, cart_id) |> Repo.preload(:items)
  end

  def checkout(return_url, %Cart{items: items, store_id: store_id} = cart) do
    %Store{stripe_account: %StripeAccount{stripe_id: stripe_id}} = Stores.get_store!(store_id)

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

  def list_products() do
    Cachex.keys!(:stripe_products) |> Enum.map(&Cachex.get!(:stripe_products, &1))
  end

  defp build_line_item(%CartItem{
         quantity: quantity,
         stripe_price_id: price
       }),
       do: %{quantity: quantity, price: price}
end
