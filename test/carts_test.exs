defmodule StripeCart.CartTest do
  use StripeCart.DataCase

  alias StripeCart.Test.FakeStripe
  alias StripeCart.Carts
  alias StripeCart.Carts.{Cart, CartItem}

  import StripeCart.Factory

  setup do
    [product, product2] = FakeStripe.populate_cache()
    stripe_account = insert(:stripe_account, stripe_id: "acc_valid_account")
    store = insert(:store, stripe_account: stripe_account)
    {:ok,
     %{
       product: product,
       product2: product2,
       store: store
     }}
  end

  describe "create_cart" do
    test "with a store", %{store: %{id: store_id}} do
      assert {:ok, cart} = Carts.create_cart(store_id)
    end
  end

  describe "add_item" do
    setup %{store: %{id: store_id}} do
      {:ok, cart} = Carts.create_cart(store_id)
      %{cart: cart}
    end
    test "to empty cart", %{product: product, cart: cart} do

      assert {:ok, %Cart{items: [%CartItem{quantity: 1, stripe_price_id: stripe_price_id, price: price, product: product_data}]}} =
               Carts.add_item(cart, "price_123")
      assert price == product.amount
      assert product.product.id == product_data["id"]
    end

    test "second product to existing cart", %{product2: product2, cart: cart} do
      assert {:ok, cart} = Carts.add_item(cart, "price_123")

      assert {:ok, %Cart{items: items}} =
               Carts.add_item(cart, "price_456")
      assert Enum.count(items) == 2
      assert "price_456" in (items |> Enum.map(& &1.stripe_price_id))
    end

    test "the same product increases quantity", %{product: product, cart: cart} do
      assert {:ok, cart} = Carts.add_item(cart, "price_123")

      assert {:ok, %Cart{items: [%CartItem{quantity: 2, stripe_price_id: "price_123"}]}} =
               Carts.add_item(cart, "price_123")
    end
  end

  describe "checkout" do
    test "checkout creates sesssion for connected account and returns url", %{store: %{id: store_id}} do
      {:ok, cart} = Carts.create_cart(store_id)

      {:ok, cart} = Carts.add_item(cart, "price_123")
      {:ok, cart} = Carts.add_item(cart, "price_456")
      return_url = "http://foo.bar"

      assert {:ok, %{url: checkout_url, success_url: ^return_url, cancel_url: ^return_url}} =
               Carts.checkout(return_url, cart)

      assert checkout_url
    end
  end
end
