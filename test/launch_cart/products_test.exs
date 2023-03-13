defmodule LaunchCart.ProductsTest do
  use LaunchCart.DataCase

  alias LaunchCart.Products
  import LaunchCart.Factory
  alias LaunchCart.Test.FakeLaunch

  describe "list_products" do
    test "fetches products and prices from stripe" do
      assert {:ok, [{"price_123", %{amount: 1100, product: %{name: "Nifty onesie"}}} | _]} =
               Products.list_products("acc_valid_account")
    end

    test "ignores accounts with invalid stripe id" do
      assert {:error, _} = Products.list_products("gargage")
    end
  end

  describe "get_product" do
    setup do
      FakeLaunch.populate_cache()
      :ok
    end

    test "with cached product" do
      assert {:ok, %{id: "price_123", amount: 1100, product: %{name: "Nifty onesie"}}} =
               Products.get_product("price_123", "acc_valid_account")
    end

    test "with non-cached product" do
      assert {:ok, %{id: "price_789", amount: 10_000_000, product: %{name: "My New House"}}} =
               Products.get_product("price_789", "acc_valid_account")
      assert {:ok, _} = Cachex.get(:stripe_products, "price_789")
      Cachex.clear!(:stripe_products)
    end

    test "with no-existent product" do
      assert {:error, _} = Products.get_product("garbage", "acc_valid_account")
    end
  end
end
