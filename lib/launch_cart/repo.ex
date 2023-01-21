defmodule LaunchCart.Repo do
  use Ecto.Repo,
    otp_app: :launch_cart,
    adapter: Ecto.Adapters.Postgres
end
