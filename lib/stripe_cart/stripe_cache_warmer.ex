defmodule StripeCart.StripeCacheWarmer do
  use Cachex.Warmer

  alias Stripe.Price
  alias Stripe.Product

  def interval() do
    :timer.seconds(300)
  end

  def execute(_state) do
    {:ok, %Stripe.List{data: stripe_products}} = Product.list(%{active: true})
    {:ok, %Stripe.List{data: stripe_prices}} = Price.list()

    products =
      stripe_products
      |> Enum.map(fn %Product{id: product_id} = product -> {product_id, product} end)
      |> Enum.into(%{})

    results =
      stripe_prices
      |> Enum.map(fn %Price{unit_amount: cents, id: price_id, product: product_id} ->
        {price_id, %{id: price_id, amount: cents, product: Map.get(products, product_id)}}
      end)

    {:ok, results}
  end
end
