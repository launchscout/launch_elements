defmodule LaunchCart.Repo do
  use Ecto.Repo,
    otp_app: :stripe_cart,
    adapter: Ecto.Adapters.Postgres
end
