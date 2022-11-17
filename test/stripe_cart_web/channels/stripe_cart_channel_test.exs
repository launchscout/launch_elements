defmodule StripeCartWeb.StripeCartChannelTest do
  use StripeCartWeb.ChannelCase

  alias StripeCart.Carts
  alias StripeCart.Test.FakeStripe

  import Phoenix.ChannelTest

  setup do
    {:ok, %{products: FakeStripe.populate_cache}}
  end

  describe "joining with new cart" do
    setup do
      {:ok, _, socket} =
        StripeCartWeb.UserSocket
        |> socket("user_id", %{some: :assign})
        |> subscribe_and_join(StripeCartWeb.StripeCartChannel, "stripe_cart:new")

      %{socket: socket}
    end

    test "add_item", %{socket: socket} do
      push(socket, "lvs_evt:add_cart_item", %{"stripe_price" => "price_123"})

      assert_push("state:change", %{
        state: %{cart: %{id: cart_id, items: [%{stripe_price_id: "price_123"}]}},
        version: 1
      })

      assert_push("cart_created", %{cart_id: ^cart_id})

      assert cart_id
    end
  end

  describe "joining with existing cart" do
    setup do
      {:ok, cart} = Carts.add_item("price_123")

      {:ok, _, socket} =
        StripeCartWeb.UserSocket
        |> socket("user_id", %{some: :assign})
        |> subscribe_and_join(StripeCartWeb.StripeCartChannel, "stripe_cart:#{cart.id}")

      %{socket: socket, cart: cart}
    end

    test "loads existing cart into state", %{cart: %{id: cart_id}} do
      assert_push("state:change", %{
        state: %{cart: %{id: ^cart_id, items: [%{stripe_price_id: "price_123"}]}},
        version: 0
      })
    end
  end

end
