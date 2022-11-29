defmodule StripeCart.StripeCacheWarmer do
  use Cachex.Warmer

  alias Stripe.Price
  alias Stripe.Product
  alias StripeCart.StripeAccounts
  alias StripeCart.StripeAccounts.StripeAccount

  def interval() do
    :timer.seconds(300)
  end

  def execute(_state) do
    results = StripeAccounts.list_stripe_accounts() |> Enum.reduce([], &get_products/2)
    {:ok, results}
  end

  defp get_products(%StripeAccount{stripe_id: stripe_id}, products) do
    case StripeAccounts.get_products(stripe_id) do
      {:ok, new_products} -> new_products ++ products
      _ -> products
    end
  end
end
