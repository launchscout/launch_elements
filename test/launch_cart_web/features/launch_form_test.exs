defmodule LaunchCartWeb.Features.LaunchFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  feature "submit form", %{session: session} do
    session
    |> visit("/fake_form")
    |> find(css("launch-form"))
  end
end
