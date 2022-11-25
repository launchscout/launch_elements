defmodule StripeCartWeb.StripeCartChannelTest do
  use StripeCartWeb.ChannelCase

  alias StripeCart.Carts
  alias StripeCart.Test.FakeStripe

  import Phoenix.ChannelTest
  import StripeCart.Factory

  setup do
    {:ok, %{products: FakeStripe.populate_cache, store: insert(:store)}}
  end

  describe "joining with new cart" do
    setup %{store: store} do
      {:ok, _, socket} =
        StripeCartWeb.UserSocket
        |> socket("user_id", %{some: :assign})
        |> subscribe_and_join(StripeCartWeb.StripeCartChannel, "stripe_cart:new", %{"store_id" => store.id})

      %{socket: socket}
    end

    test "joining adds store id to assigns", %{socket: %{assigns: %{store_id: store_id}}, store: store} do
      assert store_id == store.id
    end

    test "add_item", %{socket: socket, store: %{id: store_id}} do
      push(socket, "lvs_evt:add_cart_item", %{"stripe_price" => "price_123"})

      assert_push("state:change", %{
        state: %{cart: %{id: cart_id, items: [%{stripe_price_id: "price_123"}]}},
        version: 1
      })

      assert_push("cart_created", %{cart_id: ^cart_id})

      assert %{store_id: ^store_id} = Carts.get_cart!(cart_id)
    end
  end

  describe "joining with existing cart" do
    setup %{store: %{id: store_id}} do
      {:ok, cart} = Carts.create_cart(store_id)
      {:ok, cart} = Carts.add_item(cart, "price_123")

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
