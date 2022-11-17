defmodule StripeCart.CartTest do
  use StripeCart.DataCase

  alias StripeCart.Test.FakeStripe
  alias StripeCart.Carts
  alias StripeCart.Carts.{Cart, CartItem}

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
      assert {:ok, %Cart{items: [%CartItem{quantity: 1, stripe_price_id: stripe_price_id, price: price, product: product_data}]}} =
               Carts.add_item("price_123")
      assert price == product.amount
      assert product.product == product_data
    end

    test "second product to existing cart", %{product2: product2} do
      assert {:ok, cart} = Carts.add_item("price_123")

      assert {:ok, %Cart{items: items}} =
               Carts.add_item(cart, "price_456")
      assert Enum.count(items) == 2
      assert "price_456" in (items |> Enum.map(& &1.stripe_price_id))
    end

    test "the same product increases quantity", %{product: product} do
      assert {:ok, cart} = Carts.add_item("price_123")

      assert {:ok, %Cart{items: [%CartItem{quantity: 2, stripe_price_id: "price_123"}]}} =
               Carts.add_item(cart, "price_123")
    end
  end

  describe "checkout" do
    test "checkout returns url" do
      {:ok, cart} = Carts.add_item("price_123")
      {:ok, cart} = Carts.add_item(cart, "price_456")
      return_url = "http://foo.bar"

      assert {:ok, %{url: checkout_url, success_url: ^return_url, cancel_url: ^return_url}} =
               Carts.checkout(return_url, cart)

      assert checkout_url
    end
  end
end
