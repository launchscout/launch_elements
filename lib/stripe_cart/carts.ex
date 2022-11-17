defmodule StripeCart.Carts do
  alias StripeCart.Carts.{Cart, CartItem}

  @derive Jason.Encoder

  @create_checkout_session Application.get_env(
                             :stripe_cart,
                             :create_checkout_session,
                             &Stripe.Session.create/1
                           )

  alias StripeCart.Repo

  def get_cart!(cart_id), do: Repo.get!(Cart, cart_id) |> Repo.preload(:items)

  def add_item(price_id) do
    case Cachex.get(:stripe_products, price_id) do
      {:ok, %{id: stripe_price_id, product: product, amount: price}} ->
        Cart.create_changeset(items: [%{
          stripe_price_id: stripe_price_id,
          price: price,
          product: product,
          quantity: 1
        }])
        |> Repo.insert()

      _ ->
        {:error, "Product not found"}
    end
  end

  def add_item(cart, price_id) do
    case Cachex.get(:stripe_products, price_id) do
      {:ok, product} -> {:ok, add_product(cart, product)}
      _ -> {:error, "Product not found"}
    end
  end

  def add_product(
        %Cart{id: cart_id},
        %{id: stripe_price_id, product: product, amount: price} = stripe_data
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

  def checkout(return_url, %Cart{items: items}) do
    @create_checkout_session.(%{
      mode: "payment",
      success_url: return_url,
      cancel_url: return_url,
      shipping_address_collection: %{
        allowed_countries: ["US"]
      },
      line_items: Enum.map(items, &build_line_item/1)
    })
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
