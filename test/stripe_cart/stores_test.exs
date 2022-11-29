defmodule StripeCart.StoresTest do
  use StripeCart.DataCase

  alias StripeCart.Stores
  alias StripeCart.Stores.Store

  import StripeCart.Factory

  describe "stores" do

    @invalid_attrs %{name: nil}

    test "list_stores/0 returns all stores for a user" do
      user = insert(:user)
      other_user = insert(:user)
      store = insert(:store, user: user)
      store2 = insert(:store, user: other_user)
      assert Stores.list_stores(user) |> Enum.map(& &1.id) == [store.id]
    end

    test "get_store!/1 returns the store with given id" do
      store = insert(:store)
      assert Stores.get_store!(store.id)
    end

    test "create_store/1 with valid data creates a store" do
      user = insert(:user)
      valid_attrs = %{name: "some name", user_id: user.id}

      assert {:ok, %Store{} = store} = Stores.create_store(valid_attrs)
      assert store.name == "some name"
    end

    test "create_store with stripe account loads products" do
      stripe_account = insert(:stripe_account, stripe_id: "acc_valid_account")
      user = insert(:user)
      valid_attrs = %{name: "some name", user_id: user.id, stripe_account_id: stripe_account.id}
      assert {:ok, %Store{}} = Stores.create_store(valid_attrs)
      assert {:ok, %{product: %{name: "Happy mug"}, amount: 1100}} = Cachex.get(:stripe_products, "price_345")
      Cachex.clear!(:stripe_products)
    end

    test "create_store/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Stores.create_store(@invalid_attrs)
    end

    test "update_store/2 with valid data updates the store" do
      store = insert(:store)
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Store{} = updated_store} = Stores.update_store(store, update_attrs)
      assert updated_store.name == "some updated name"
    end

    test "update_store with a stripe account loads products" do
      store = insert(:store)
      stripe_account = insert(:stripe_account, stripe_id: "acc_valid_account")
      assert {:ok, _store} = Stores.update_store(store, %{stripe_account_id: stripe_account.id})
      assert {:ok, %{product: %{name: "Happy mug"}, amount: 1100}} = Cachex.get(:stripe_products, "price_345")
      Cachex.clear!(:stripe_products)
    end

    test "update_store/2 with invalid data returns error changeset" do
      store = insert(:store)
      assert {:error, %Ecto.Changeset{}} = Stores.update_store(store, @invalid_attrs)
    end

    test "delete_store/1 deletes the store" do
      store = insert(:store)
      assert {:ok, %Store{}} = Stores.delete_store(store)
      assert_raise Ecto.NoResultsError, fn -> Stores.get_store!(store.id) end
    end

    test "change_store/1 returns a store changeset" do
      store = insert(:store)
      assert %Ecto.Changeset{} = Stores.change_store(store)
    end
  end

end
