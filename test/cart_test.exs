defmodule StripeCart.CartTest do
  use StripeCart.DataCase

  alias StripeCart.Test.FakeStripe
  alias StripeCart.{Cart, CartItem}

  setup do
    [product, product2] = FakeStripe.populate_cache()
    {:ok,
     %{
       product: product,
       product2: product2
     }}
  end

  describe "add_item" do
    test "to empty cart", %{product: product} do
      assert {:ok, %Cart{items: [%CartItem{quantity: 1, product: ^product}]}} =
               Cart.add_item("price_123")
    end

    test "second product to existing cart", %{product2: product2} do
      assert {:ok, cart} = Cart.add_item("price_123")

      assert {:ok, %Cart{items: [_item, %CartItem{quantity: 1, product: ^product2}]}} =
               Cart.add_item(cart, "price_456")
    end

    test "the same product increases quantity", %{product: product} do
      assert {:ok, cart} = Cart.add_item("price_123")

      assert {:ok, %Cart{items: [%CartItem{quantity: 2, product: ^product}]}} =
               Cart.add_item(cart, "price_123")
    end
  end

  describe "checkout" do
    test "checkout returns url" do
      {:ok, cart} = Cart.add_item("price_123")
      {:ok, cart} = Cart.add_item(cart, "price_456")
      return_url = "http://foo.bar"

      assert {:ok, %{url: checkout_url, success_url: ^return_url, cancel_url: ^return_url}} =
               Cart.checkout(return_url, cart)

      assert checkout_url
    end
  end
end
