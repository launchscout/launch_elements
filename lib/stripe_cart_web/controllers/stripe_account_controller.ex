defmodule StripeCartWeb.StripeAccountController do
  use StripeCartWeb, :controller

  alias StripeCartWeb.Router.Helpers

  alias StripeCart.StripeAccounts
  alias StripeCart.StripeAccounts.StripeAccount

  @stripe_client_id "ca_MgHqblogEu5kjraESIVJRE0KxhPTf44n"

  def stripe_oauth do
    Application.get_env(:stripe_cart, :stripe_oauth, Stripe.Connect.OAuth)
  end

  def stripe_client_id do
    Application.get_env(:stripe_cart, :stripe_client_id)
  end

  def index(conn, _params) do
    stripe_accounts = StripeAccounts.list_stripe_accounts()
    render(conn, "index.html", stripe_accounts: stripe_accounts)
  end

  def new(conn, _params) do
    changeset = StripeAccounts.change_stripe_account(%StripeAccount{})
    render(conn, "new.html", changeset: changeset)
  end

  def authorize_stripe(conn, _params) do
    return_url = Helpers.stripe_account_url(conn, :connect_account)
    url = Stripe.Connect.OAuth.authorize_url(%{redirect_uri: return_url, client_id: @stripe_client_id})
    redirect(conn, external: url)
  end

  def connect_account(conn, %{"code" => code}) do
    IO.inspect(code)
    # {:ok, account} = Stripe.Connect.OAuth.token(code)
    render(conn, "account_connected.html", account: nil)
  end

  def create(conn, %{"stripe_account" => stripe_account_params}) do
    case StripeAccounts.create_stripe_account(stripe_account_params) do
      {:ok, stripe_account} ->
        conn
        |> put_flash(:info, "Stripe account created successfully.")
        |> redirect(to: Routes.stripe_account_path(conn, :show, stripe_account))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    stripe_account = StripeAccounts.get_stripe_account!(id)
    render(conn, "show.html", stripe_account: stripe_account)
  end

  def edit(conn, %{"id" => id}) do
    stripe_account = StripeAccounts.get_stripe_account!(id)
    changeset = StripeAccounts.change_stripe_account(stripe_account)
    render(conn, "edit.html", stripe_account: stripe_account, changeset: changeset)
  end

  def update(conn, %{"id" => id, "stripe_account" => stripe_account_params}) do
    stripe_account = StripeAccounts.get_stripe_account!(id)

    case StripeAccounts.update_stripe_account(stripe_account, stripe_account_params) do
      {:ok, stripe_account} ->
        conn
        |> put_flash(:info, "Stripe account updated successfully.")
        |> redirect(to: Routes.stripe_account_path(conn, :show, stripe_account))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", stripe_account: stripe_account, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    stripe_account = StripeAccounts.get_stripe_account!(id)
    {:ok, _stripe_account} = StripeAccounts.delete_stripe_account(stripe_account)

    conn
    |> put_flash(:info, "Stripe account deleted successfully.")
    |> redirect(to: Routes.stripe_account_path(conn, :index))
  end
end
