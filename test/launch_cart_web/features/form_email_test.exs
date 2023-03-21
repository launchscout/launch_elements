defmodule LaunchCartWeb.Features.FormEmailTest do
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

  feature "adding an email", %{session: session, user: user, form: form} do
    session
    |> visit("/users/log_in")
    |> fill_in(text_field("Email"), with: user.email)
    |> fill_in(text_field("Password"), with: "password")
    |> click(css("button"))
    |> visit("/forms/#{form.id}")
    |> assert_text(form.name)
    |> find(css("form-emails"))
    |> shadow_root()
    |> click(css("#add-form-email"))
    |> fill_in(css("input[name='subject']"), with: "An email")
    |> fill_in(css("input[name='email']"), with: "chris@foo.bar")
    |> click(css("#save-form-email"))
    |> assert_has(css("td", text: "chris@foo.bar"))
  end

end
