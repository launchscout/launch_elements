defmodule LaunchCartWeb.StripeAccountController do
  use LaunchCartWeb, :controller

  alias LaunchCart.StripeAccounts
  alias LaunchCart.StripeAccounts.StripeAccount

  @stripe_client_id "ca_MgHqblogEu5kjraESIVJRE0KxhPTf44n"

  def stripe_oauth do
    Application.get_env(:launch_cart, :stripe_oauth, Stripe.Connect.OAuth)
  end

  def stripe_client_id do
    Application.get_env(:launch_cart, :stripe_client_id)
  end

  def index(%{assigns: %{current_user: current_user}} = conn, _params) do
    stripe_accounts = StripeAccounts.list_stripe_accounts(current_user)
    render(conn, "index.html", stripe_accounts: stripe_accounts)
  end

  def new(conn, _params) do
    changeset = StripeAccounts.change_stripe_account(%StripeAccount{})
    render(conn, "new.html", changeset: changeset)
  end

  def authorize_stripe(conn, _params) do
    return_url = Routes.stripe_account_url(conn, :connect_account)
    url = Stripe.Connect.OAuth.authorize_url(%{redirect_uri: return_url, client_id: @stripe_client_id})
    redirect(conn, external: url)
  end

  def connect_account(%{assigns: %{current_user: user}} = conn, %{"code" => code}) do
    {:ok, account} = stripe_oauth().token(code)
    {:ok, _} = StripeAccounts.create_stripe_account(user, account)
    redirect(conn, to: Routes.stripe_account_path(conn, :index))
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
        |> put_flash(:info, "Launch account updated successfully.")
        |> redirect(to: Routes.stripe_account_path(conn, :show, stripe_account))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", stripe_account: stripe_account, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    stripe_account = StripeAccounts.get_stripe_account!(id)
    {:ok, _stripe_account} = StripeAccounts.delete_stripe_account(stripe_account)

    conn
    |> put_flash(:info, "Launch account deleted successfully.")
    |> redirect(to: Routes.stripe_account_path(conn, :index))
  end
end
