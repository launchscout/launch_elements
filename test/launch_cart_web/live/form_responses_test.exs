defmodule LaunchCartWeb.FormResponsesTest do
  use LaunchCartWeb.ConnCase

  import Phoenix.LiveViewTest
  import LaunchCart.Factory


  setup(%{conn: conn}) do
    user = insert(:user)
    conn = log_in_user(conn, user)
    %{user: user, conn: conn}
  end

  defp create_form(%{user: user}) do
    form = insert(:form, user: user)
    %{form: form}
  end

  describe "Index" do
    setup [:create_form]

    test "lists all form reponses for form", %{conn: conn, form: form} do
      insert(:form_response, form: form, response: %{foo: "bar"})
      insert(:form_response, form: form, response: %{foo: "wuzzle", bing: "baz"})
      {:ok, _index_live, html} = live(conn, Routes.form_form_responses_path(conn, :index, form))

      assert html =~ "Listing Form Responses"
      assert html =~ "foo: bar"
      assert html =~ "bing: baz"
    end
  end
end
