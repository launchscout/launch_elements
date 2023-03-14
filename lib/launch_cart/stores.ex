defmodule LaunchCart.Stores do
  @moduledoc """
  The Stores context.
  """

  import Ecto.Query, warn: false
  alias LaunchCart.Products
  alias LaunchCart.Repo

  alias LaunchCart.Stores.Store
  alias LaunchCart.Accounts.User
  alias LaunchCart.StripeAccounts.StripeAccount
  alias LaunchCart.StripeAccounts

  @doc """
  Returns the list of stores.

  ## Examples

      iex> list_stores()
      [%Store{}, ...]

  """
  def list_stores do
    Repo.all(Store)
  end

  def list_stores(%User{id: user_id}) do
    Repo.all(from store in Store, where: store.user_id == ^user_id)
  end

  @doc """
  Gets a single store.

  Raises `Ecto.NoResultsError` if the Store does not exist.

  ## Examples

      iex> get_store!(123)
      %Store{}

      iex> get_store!(456)
      ** (Ecto.NoResultsError)

  """
  def get_store!(id), do: Repo.get!(Store, id) |> Repo.preload(:stripe_account)

  @doc """
  Creates a store.

  ## Examples

      iex> create_store(%{field: value})
      {:ok, %Store{}}

      iex> create_store(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_store(attrs \\ %{}) do
    case %Store{}
         |> Store.changeset(attrs)
         |> Repo.insert() do
      {:ok, store} ->
        load_products(store)
        {:ok, store}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Updates a store.

  ## Examples

      iex> update_store(store, %{field: new_value})
      {:ok, %Store{}}

      iex> update_store(store, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_store(%Store{} = store, attrs) do
    case store
         |> Store.changeset(attrs)
         |> Repo.update() do
      {:ok, store} ->
        # reload to fix odd situation where the stripe account id doesn't match the stripe account
        load_products(Repo.reload!(store))
        {:ok, store}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Deletes a store.

  ## Examples

      iex> delete_store(store)
      {:ok, %Store{}}

      iex> delete_store(store)
      {:error, %Ecto.Changeset{}}

  """
  def delete_store(%Store{} = store) do
    Repo.delete(store)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking store changes.

  ## Examples

      iex> change_store(store)
      %Ecto.Changeset{data: %Store{}}

  """
  def change_store(%Store{} = store, attrs \\ %{}) do
    Store.changeset(store, attrs)
  end

  def load_products(%Store{stripe_account: %StripeAccount{stripe_id: connected_account}})
      when not is_nil(connected_account) do
    case Products.list_products(connected_account) do
      {:ok, products} -> Cachex.put_many!(:stripe_products, products)
      _ -> nil
    end
  end

  def load_products(%Store{stripe_account: %Ecto.Association.NotLoaded{}} = store) do
    Repo.preload(store, :stripe_account) |> load_products()
  end

  def load_products(_), do: nil

end
