defmodule StripeCartWeb.LayoutView do
  use StripeCartWeb, :view

  alias Phoenix.LiveView.JS

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}

  defp toggle_class(js \\ %JS{}, clazz, selector) do
    js
    |> JS.remove_class(clazz, to: selector)
    |> JS.add_class(clazz, to: selector <> ":not(.#{clazz})")
  end
end
