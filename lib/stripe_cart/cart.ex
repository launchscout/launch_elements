defmodule StripeCart.Cart do
  alias StripeCart.{Cart, CartItem}

  @derive Jason.Encoder

  @create_checkout_session Application.get_env(
                             :stripe_cart,
                             :create_checkout_session,
                             &Stripe.Session.create/1
                           )

  defstruct items: [], id: nil

  def add_item(price_id) do
    case Cachex.get(:stripe_products, price_id) do
      {:ok, product} -> {:ok, %Cart{items: [%CartItem{quantity: 1, product: product}]}}
      _ -> {:error, "Product not found"}
    end
  end

  def add_item(cart, price_id) do
    case Cachex.get(:stripe_products, price_id) do
      {:ok, product} -> {:ok, add_product(cart, product)}
      _ -> {:error, "Product not found"}
    end
  end

  def add_product(%Cart{items: items}, product) do
    case Enum.find_index(items, fn %CartItem{product: cart_product} ->
           cart_product.id == product.id
         end) do
      nil ->
        %Cart{items: items ++ [%CartItem{quantity: 1, product: product}]}

      index ->
        %CartItem{quantity: quantity} = Enum.at(items, index)

        %Cart{
          items:
            List.replace_at(items, index, %CartItem{product: product, quantity: quantity + 1})
        }
    end
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
         product: %{id: price}
       }),
       do: %{quantity: quantity, price: price}
end
