defmodule StripeCartWeb.PageController do
  use StripeCartWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
