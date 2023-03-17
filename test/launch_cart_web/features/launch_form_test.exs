defmodule LaunchCartWeb.Features.LaunchFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias LaunchCart.Forms

  import Wallaby.Query
  import LaunchCart.Factory

  setup do
    form = insert(:form)
    {:ok, %{form: form}}
  end

  feature "submit form", %{session: session, form: form} do
    session
    |> visit("/fake_form/#{form.id}")
    |> find(css("launch-form"))
    |> fill_in(text_field("first_name"), with: "Bob")
    |> fill_in(text_field("last_name"), with: "Jones")
    |> click(css("button"))
    |> assert_text("It totally worked")

    assert %{responses: [%{response: %{"first_name" => "Bob", "last_name" => "Jones"}}]} =
             Forms.get_form!(form.id)
  end
end
