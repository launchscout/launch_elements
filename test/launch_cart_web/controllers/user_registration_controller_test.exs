defmodule LaunchCartWeb.UserRegistrationControllerTest do
  alias ExDoc.Language
  use LaunchCartWeb.ConnCase, async: true

  import LaunchCart.AccountsFixtures
  import LaunchCart.Factory

  describe "GET /users/register" do
    test "renders registration page", %{conn: conn} do
      conn = get(conn, Routes.user_registration_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "Help us test Launch Elements!"
      assert response =~ "Log in</a>"
      assert response =~ "Register</a>"
      Excessibility.html_snapshot(conn)
    end

    test "redirects if already logged in", %{conn: conn} do
      conn = conn |> log_in_user(insert(:user)) |> get(Routes.user_registration_path(conn, :new))
      assert redirected_to(conn) == "/stripe_accounts"
    end
  end

  describe "POST /users/register" do
    @tag :capture_log
    test "thanks the user", %{conn: conn} do
      email = unique_user_email()

      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => %{email: email}
        })

      response = html_response(conn, 200)
      assert response =~ "Thanks"
      Excessibility.html_snapshot(conn)
    end
  end
end
