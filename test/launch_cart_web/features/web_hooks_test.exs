defmodule LaunchCartWeb.Features.LaunchFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias LaunchCart.Forms

  import Wallaby.Query
  import LaunchCart.Factory

  setup do
    form = insert(:form)
    user = insert(:user)

    {:ok, %{form: form, user: user}}
  end

  feature "adding a web hook", %{session: session, user: user, form: form} do
    session
    |> visit("/users/log_in")
    |> fill_in(text_field("Email"), with: user.email)
    |> fill_in(text_field("Password"), with: "password")
    |> click(css("button"))
    |> visit("/forms/#{form.id}")
    |> assert_text(form.name)
    |> find(css("web-hooks"))
    |> shadow_root()
    |> click(css("#add-web-hook"))
    |> fill_in(css("input[name='description']"), with: "My new webhook")
    |> fill_in(css("input[name='url']"), with: "http://www.cnn.com")
    |> click(css("#save-web-hook"))
    |> assert_has(css("td", text: "My new webhook"))
  end

end
