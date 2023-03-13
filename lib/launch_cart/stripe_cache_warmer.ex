defmodule LaunchCart.LaunchCacheWarmer do
  use Cachex.Warmer

  alias LaunchCart.Products
  alias LaunchCart.StripeAccounts
  alias LaunchCart.StripeAccounts.StripeAccount

  def interval() do
    :timer.seconds(300)
  end

  def execute(_state) do
    results = StripeAccounts.list_stripe_accounts() |> Enum.reduce([], &get_products/2)
    {:ok, results}
  end

  defp get_products(%StripeAccount{stripe_id: stripe_id}, products) do
    case Products.list_products(stripe_id) do
      {:ok, new_products} -> new_products ++ products
      _ -> products
    end
  end
end
