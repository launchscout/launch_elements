defmodule LaunchCartWeb.Features.LaunchCartTest do
  alias LaunchCartWeb.PallyTest
  alias LaunchCart.Test.FakeLaunch
  use ExUnit.Case, async: false
  use Wallaby.Feature
  use LaunchCartWeb.PallyTest

  import Wallaby.Query
  import LaunchCart.Factory

  alias LaunchCart.Repo
  alias LaunchCart.Carts.Cart

  setup do
    products = FakeLaunch.populate_cache()
    store = insert(:store)
    {:ok, %{products: products, store: store}}
  end

  feature "add item", %{session: session, store: store} do
    session
    |> visit("/fake_stores/#{store.id}")
    |> assert_text("My Store")
    |> click(css("button#add-price_123"))
    |> find(css("launch-cart"))
    |> shadow_root()
    |> assert_has(css(".cart-count", text: "1"))
    |> click(css(".cart-count"))
    |> assert_has(css("dialog"))
    |> assert_has(css("table", text: "Nifty onesie"))

    PallyTest.here(session)

    assert Repo.get_by(Cart, store_id: store.id)
  end

  feature "alter quantity", %{session: session, store: store} do
    session
    |> visit("/fake_stores/#{store.id}")
    |> assert_text("My Store")
    |> click(css("button#add-price_123"))
    |> find(css("launch-cart"))
    |> shadow_root()
    |> assert_has(css(".cart-count", text: "1"))
    |> click(css(".cart-count"))
    |> assert_has(css("table", text: "Nifty onesie"))
    |> assert_has(css("td[part='cart-summary-qty']", text: "1"))
    |> click(css("button[part='cart-increase-qty-button']"))
    |> assert_has(css("td[part='cart-summary-qty']", text: "2"))
    |> click(css("button[part='cart-decrease-qty-button']"))
    |> assert_has(css("td[part='cart-summary-qty']", text: "1"))

    PallyTest.here(session)
  end

  feature "add item and reload", %{session: session, store: store} do
    session
    |> visit("/fake_stores/#{store.id}")
    |> assert_text("My Store")
    |> click(css("button#add-price_123"))
    |> find(css("launch-cart"))
    |> shadow_root()
    |> assert_has(css(".cart-count", text: "1"))

    session
    |> visit("/fake_stores/#{store.id}")
    |> find(css("launch-cart"))
    |> shadow_root()
    |> assert_has(css(".cart-count", text: "1"))

    PallyTest.here(session)
  end

  feature "after checkout", %{session: session, store: store} do
    cart = insert(:cart, store: store, status: :checkout_complete)

    session
    |> visit("/fake_stores/#{store.id}")
    |> execute_script("""
      console.log('cart id: #{cart.id}');
      window.localStorage.setItem('cart_id', '#{cart.id}');
    """)
    |> assert_text("My Store")
    |> visit("/fake_stores/#{store.id}")
    |> assert_text("My Store")
    |> find(css("launch-cart"))
    |> shadow_root()
    |> assert_has(css("dialog", text: "OMG Thanks"))

    PallyTest.here(session)
  end

  feature "remove item from cart", %{session: session, store: store} do
    session
    |> visit("/fake_stores/#{store.id}")
    |> assert_text("My Store")
    |> click(css("button#add-price_123"))
    |> find(css("launch-cart"))
    |> shadow_root()
    |> assert_has(css(".cart-count", text: "1"))
    |> click(css("button"))
    |> assert_has(css("td", text: "Nifty onesie"))
    |> click(css("button#remove-item"))
    |> assert_has(css("td", text: "Nifty onesie", count: 0))

    PallyTest.here(session)

    cart = Repo.get_by(Cart, store_id: store.id) |> Repo.preload(:items)
    assert Enum.count(cart.items) == 0
  end
end
