defmodule StripeCart.StoresTest do
  use StripeCart.DataCase

  alias StripeCart.Stores

  import StripeCart.Factory

  describe "stores" do
    alias StripeCart.Stores.Store

    import StripeCart.StoresFixtures

    @invalid_attrs %{name: nil, stripe_customer_id: nil}

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
      valid_attrs = %{name: "some name", user_id: user.id, stripe_customer_id: "some stripe_customer_id"}

      assert {:ok, %Store{} = store} = Stores.create_store(valid_attrs)
      assert store.name == "some name"
      assert store.stripe_customer_id == "some stripe_customer_id"
    end

    test "create_store/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Stores.create_store(@invalid_attrs)
    end

    test "update_store/2 with valid data updates the store" do
      store = insert(:store)
      update_attrs = %{name: "some updated name", stripe_customer_id: "some updated stripe_customer_id"}

      assert {:ok, %Store{} = store} = Stores.update_store(store, update_attrs)
      assert store.name == "some updated name"
      assert store.stripe_customer_id == "some updated stripe_customer_id"
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
