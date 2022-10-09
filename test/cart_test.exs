defmodule StripeCart.CartTest do
  use StripeCart.DataCase

  alias StripeCart.{Cart, CartItem}

  setup do
    product = %{
      amount: 1100,
      id: "price_123",
      product: %Stripe.Product{
        active: true,
        attributes: [],
        caption: nil,
        created: 1_664_649_973,
        deactivate_on: nil,
        default_price: "price_1LoAhVKFGxMzGbgkUgrHPg0z",
        deleted: nil,
        description: "Awww cuuute wah wah wah babies",
        id: "prod_MXFBKgirbzb0dw",
        images: [
          "https://files.stripe.com/links/MDB8YWNjdF8xSTQ2a3FLRkd4TXpHYmdrfGZsX3Rlc3Rfa2psMk5KcERPelRWeGp3OVpDT1oxcXhE004CuzJnnL"
        ],
        livemode: false,
        metadata: %{},
        name: "Nifty onesie",
        object: "product",
        package_dimensions: nil,
        shippable: nil,
        statement_descriptor: nil,
        type: "service",
        unit_label: nil,
        updated: 1_664_649_974,
        url: nil
      }
    }

    product2 = %{
      amount: 1000,
      id: "price_456",
      product: %Stripe.Product{
        active: true,
        attributes: [],
        caption: nil,
        created: 1_664_649_973,
        deactivate_on: nil,
        default_price: "price_1LoAhVKFGxMzGbgkUgrHPg0z",
        deleted: nil,
        description: "Put liquid in it. Or don't its up to you",
        id: "prod_456",
        images: [
          "https://files.stripe.com/links/MDB8YWNjdF8xSTQ2a3FLRkd4TXpHYmdrfGZsX3Rlc3Rfa2psMk5KcERPelRWeGp3OVpDT1oxcXhE004CuzJnnL"
        ],
        livemode: false,
        metadata: %{},
        name: "Groovy cup",
        object: "product",
        package_dimensions: nil,
        shippable: nil,
        statement_descriptor: nil,
        type: "service",
        unit_label: nil,
        updated: 1_664_649_974,
        url: nil
      }
    }

    Cachex.put!(:stripe_products, "price_123", product)
    Cachex.put!(:stripe_products, "price_456", product2)

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
end
