defmodule LaunchCart.Products do

  def list_products(stripe_id) do
    with {:ok, %Stripe.List{data: stripe_products}} <-
           fetch_stripe_products(%{active: true}, connect_account: stripe_id),
         {:ok, %Stripe.List{data: stripe_prices}} <-
           fetch_stripe_prices(%{}, connect_account: stripe_id) do
      products =
        stripe_products
        |> Enum.map(fn %Stripe.Product{id: product_id} = product -> {product_id, product} end)
        |> Enum.into(%{})

      results =
        stripe_prices
        |> Enum.map(fn %Stripe.Price{unit_amount: cents, id: price_id, product: product_id} ->
          {price_id, %{id: price_id, amount: cents, product: Map.get(products, product_id)}}
        end)

      {:ok, results}
    end
  end

  defp fetch_stripe_products(params, options) do
    func = Application.get_env(:launch_cart, :list_stripe_products, &Stripe.Product.list/2)
    func.(params, options)
  end

  defp fetch_stripe_prices(params, options) do
    func = Application.get_env(:launch_cart, :list_stripe_prices, &Stripe.Price.list/2)
    func.(params, options)
  end

end
