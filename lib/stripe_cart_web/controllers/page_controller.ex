defmodule StripeCartWeb.PageController do
  use StripeCartWeb, :controller
  alias StripeCartWeb.Endpoint

  alias StripeCart.Carts
  alias StripeCart.Stores

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def fake_store(conn, %{"store_id" => store_id}) do
    store = Stores.get_store!(store_id)
    url =
      "#{String.replace(Endpoint.url(), "http:", "ws:")}/socket" |> IO.inspect()
    render(conn, "fake_store.html", products: Carts.list_products(), url: url, store: store)
  end
end
