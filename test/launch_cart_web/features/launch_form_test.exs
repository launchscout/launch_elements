defmodule LaunchCartWeb.Features.LaunchFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias LaunchCart.Repo
  alias LaunchCart.Forms

  import Wallaby.Query
  import LaunchCart.Factory

  setup do
    bypass = Bypass.open()
    form = insert(:form)
    web_hook = insert(:web_hook, form: form, url: "http://localhost:#{bypass.port}/hook")

    Bypass.expect_once(bypass, "POST", "/hook", fn conn ->
      Plug.Conn.resp(conn, 200, "")
    end)

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
             Forms.get_form!(form.id) |> Repo.preload(:responses)
  end
end
