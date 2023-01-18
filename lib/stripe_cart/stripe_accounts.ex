defmodule LaunchCart.StripeAccounts do
  @moduledoc """
  The StripeAccounts context.
  """

  import Ecto.Query, warn: false
  alias LaunchCart.Repo

  alias LaunchCart.Accounts.User
  alias LaunchCart.StripeAccounts.StripeAccount

  def fetch_stripe_account(id) do
    func = Application.get_env(:stripe_cart, :get_stripe_account, &Launch.Account.retrieve/1)
    func.(id)
  end

  @doc """
  Returns the list of stripe_accounts.

  ## Examples

      iex> list_stripe_accounts()
      [%StripeAccount{}, ...]

  """

  def list_stripe_accounts(), do: Repo.all(StripeAccount)

  def list_stripe_accounts(%User{id: user_id}), do: list_stripe_accounts(user_id)

  def list_stripe_accounts(user_id) do
    Repo.all(from stripe_account in StripeAccount, where: stripe_account.user_id == ^user_id)
  end

  @doc """
  Gets a single stripe_account.

  Raises `Ecto.NoResultsError` if the Launch account does not exist.

  ## Examples

      iex> get_stripe_account!(123)
      %StripeAccount{}

      iex> get_stripe_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_stripe_account!(id), do: Repo.get!(StripeAccount, id)

  @doc """
  Creates a stripe_account.

  ## Examples

      iex> create_stripe_account(%{field: value})
      {:ok, %StripeAccount{}}

      iex> create_stripe_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_stripe_account(%User{id: user_id}, %{stripe_user_id: stripe_user_id}) do
    case fetch_stripe_account(stripe_user_id) do
      {:ok, %Stripe.Account{business_profile: %{name: name}}} ->
        %StripeAccount{}
        |> StripeAccount.changeset(%{user_id: user_id, stripe_id: stripe_user_id, name: name})
        |> Repo.insert()

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  Updates a stripe_account.

  ## Examples

      iex> update_stripe_account(stripe_account, %{field: new_value})
      {:ok, %StripeAccount{}}

      iex> update_stripe_account(stripe_account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_stripe_account(%StripeAccount{} = stripe_account, attrs) do
    stripe_account
    |> StripeAccount.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a stripe_account.

  ## Examples

      iex> delete_stripe_account(stripe_account)
      {:ok, %StripeAccount{}}

      iex> delete_stripe_account(stripe_account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stripe_account(%StripeAccount{} = stripe_account) do
    Repo.delete(stripe_account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking stripe_account changes.

  ## Examples

      iex> change_stripe_account(stripe_account)
      %Ecto.Changeset{data: %StripeAccount{}}

  """
  def change_stripe_account(%StripeAccount{} = stripe_account, attrs \\ %{}) do
    StripeAccount.changeset(stripe_account, attrs)
  end

  def get_products(stripe_id) do
    with {:ok, %Stripe.List{data: stripe_products}} <-
           fetch_stripe_products(%{active: true}, connect_account: stripe_id),
         {:ok, %Stripe.List{data: stripe_prices}} <-
           fetch_stripe_prices(%{}, connect_account: stripe_id) do
      products =
        stripe_products
        |> Enum.map(fn %Stripe.Product{id: product_id} = product -> {product_id, product} end)
        |> Enum.into(%{})

      results =
        stripe_prices
        |> Enum.map(fn %Stripe.Price{unit_amount: cents, id: price_id, product: product_id} ->
          {price_id, %{id: price_id, amount: cents, product: Map.get(products, product_id)}}
        end)

      {:ok, results}
    end
  end

  defp fetch_stripe_products(params, options) do
    func = Application.get_env(:stripe_cart, :list_stripe_products, &Stripe.Product.list/2)
    func.(params, options)
  end

  defp fetch_stripe_prices(params, options) do
    func = Application.get_env(:stripe_cart, :list_stripe_prices, &Launch.Price.list/2)
    func.(params, options)
  end
end
