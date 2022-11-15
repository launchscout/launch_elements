defmodule StripeCartWeb.PageController do
  use StripeCartWeb, :controller
  alias StripeCartWeb.Endpoint

  alias StripeCart.Cart

  def index(conn, _params) do
    url =
      "#{String.replace(Endpoint.url(), "http:", "ws:")}/socket" |> IO.inspect()
    render(conn, "index.html", products: Cart.list_products(), url: url)
  end
end
