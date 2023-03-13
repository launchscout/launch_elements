defmodule LaunchCart.ProductsTest do
  use LaunchCart.DataCase

  alias LaunchCart.Products
  import LaunchCart.Factory


  describe "list_products" do
    test "fetches products and prices from stripe" do
      assert {:ok, [{"price_123", %{amount: 1100, product: %{name: "Nifty onesie"}}} | _] } = Products.list_products("acc_valid_account")
    end

    test "ignores accounts with invalid stripe id" do
      assert {:error, _} = Products.list_products("gargage")
    end
  end

end
