defmodule LaunchCartWeb.UserRegistrationControllerTest do
  alias ExDoc.Language
  use LaunchCartWeb.ConnCase, async: true

  alias LaunchCart.Repo
  alias LaunchCart.Accounts.{User, UserToken}

  import LaunchCart.AccountsFixtures
  import LaunchCart.Factory

  describe "GET /users/register" do
    test "renders registration page", %{conn: conn} do
      conn = get(conn, Routes.user_registration_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "Launch Elements enters Open Beta"
      assert response =~ "Log in</a>"
      assert response =~ "Register</a>"
      PallyTest.here(conn)
    end

    test "redirects if already logged in", %{conn: conn} do
      conn = conn |> log_in_user(insert(:user)) |> get(Routes.user_registration_path(conn, :new))
      assert redirected_to(conn) == "/stripe_accounts"
    end
  end

  describe "POST /users/register" do
    @tag :capture_log
    test "thanks the user and sends confirmation email", %{conn: conn} do
      email = unique_user_email()

      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => %{email: email, password: "Password1235", password_confirmation: "Password1235"}
        })

      response = html_response(conn, 200)
      assert response =~ "Thanks"

      assert user = Repo.get_by!(User, email: email)
      assert Repo.get_by!(UserToken, user_id: user.id).context == "confirm"

      PallyTest.here(conn)
    end
  end
end
