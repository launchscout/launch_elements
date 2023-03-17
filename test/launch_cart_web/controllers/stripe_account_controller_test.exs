defmodule LaunchCartWeb.StripeAccountControllerTest do
  use LaunchCartWeb.ConnCase

  alias LaunchCart.Repo
  alias LaunchCart.StripeAccounts.StripeAccount

  import LaunchCart.Factory

  setup :register_and_log_in_user

  @create_attrs %{name: "some name", stripe_id: "some stripe_id"}
  @update_attrs %{name: "some updated name", stripe_id: "some updated stripe_id"}
  @invalid_attrs %{name: nil, stripe_id: nil}

  describe "index" do
    test "lists all stripe_accounts", %{conn: conn} do
      conn = get(conn, Routes.stripe_account_path(conn, :index))
      assert html_response(conn, 200) =~ "Connected Stripe Accounts"
      Excessibility.html_snapshot(conn)
    end
  end

  describe "delete stripe_account" do
    setup [:create_stripe_account]

    test "deletes chosen stripe_account", %{conn: conn, stripe_account: stripe_account} do
      conn = delete(conn, Routes.stripe_account_path(conn, :delete, stripe_account))
      assert redirected_to(conn) == Routes.stripe_account_path(conn, :index)
    end
  end

  describe "connect_account" do
    test "stripe callback with valid code", %{conn: conn, user: user} do
      conn =
        get(conn, Routes.stripe_account_path(conn, :connect_account), %{"code" => "ac_valid"})

      assert redirected_to(conn) == Routes.stripe_account_path(conn, :index)
      assert Repo.get_by(StripeAccount, user_id: user.id)
    end

    test "with invalid code", %{conn: conn} do
    end
  end

  defp create_stripe_account(_) do
    stripe_account = insert(:stripe_account)
    %{stripe_account: stripe_account}
  end
end
