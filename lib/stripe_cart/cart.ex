defmodule StripeCart.Cart do
  alias StripeCart.{Cart, CartItem}

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

  @tag timeout: :infinity
  def add_product(%Cart{items: items}, product) do
    case Enum.find_index(items, fn %CartItem{product: cart_product} -> cart_product.id == product.id end) do
      nil ->
        %Cart{items: items ++ [%CartItem{quantity: 1, product: product}]}

      index ->
        %CartItem{quantity: quantity} = Enum.at(items, index)
        %Cart{
          items: List.replace_at(items, index, %CartItem{product: product, quantity: quantity + 1})
        }
    end
  end
end
