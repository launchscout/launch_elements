defmodule LaunchCartWeb.Features.LaunchFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature
  import Wallaby.Query

  feature "submit form", %{session: session} do
    session
    |> visit("/fake_form")
    |> find(css("launch-form"))
    |> assert_has(css("#first-name"))
    |> fill_in(text_field("first_name"), with: "Bob")
    |> fill_in(text_field("last_name"), with: "Jones")
    |> click(css("button"))
    |> assert_text("It totally worked")
  end
end
