defmodule StripeCartWeb.Features.StripeCartTest do
  alias StripeCart.Test.FakeStripe
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query
  import StripeCart.Factory

  alias StripeCart.Repo
  alias StripeCart.Carts.Cart

  setup do
    products = FakeStripe.populate_cache()
    store = insert(:store)
    {:ok, %{products: products, store: store}}
  end

  feature "add item", %{session: session, store: store} do
    session
    |> visit("/fake_stores/#{store.id}")
    |> assert_text("My Store")
    |> click(css("button#add-price_123"))
    |> within_shadow_dom("stripe-cart", fn shadow_dom ->
      shadow_dom
      |> assert_has(css("sl-badge", text: "1"))
      |> click(css("sl-button"))
      |> assert_has(css("table", text: "Nifty onesie"))
    end)
    assert Repo.get_by(Cart, store_id: store.id)
  end

  feature "add item and reload", %{session: session, store: store} do
    session
    |> visit("/fake_stores/#{store.id}")
    |> assert_text("My Store")
    |> click(css("button#add-price_123"))
    |> within_shadow_dom("stripe-cart", fn shadow_dom ->
      shadow_dom
      |> assert_has(css("sl-badge", text: "1"))
    end)
    |> visit("/fake_stores/#{store.id}")
    |> within_shadow_dom("stripe-cart", fn shadow_dom ->
      shadow_dom
      |> assert_has(css("sl-badge", text: "1"))
    end)
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
    |> within_shadow_dom("stripe-cart", fn shadow_dom ->
      shadow_dom
      |> assert_has(css("sl-dialog", text: "Thanks"))
    end)
  end

  feature "remove item from cart", %{session: session, store: store} do
    session
    |> visit("/fake_stores/#{store.id}")
    |> assert_text("My Store")
    |> click(css("button#add-price_123"))
    |> within_shadow_dom("stripe-cart", fn shadow_dom ->
      shadow_dom
      |> assert_has(css("sl-badge", text: "1"))
      |> click(css("sl-button"))
      |> assert_has(css("td", text: "Nifty onesie"))
      |> click(css("sl-button#remove-item"))
      |> assert_has(css("td", text: "Nifty onesie", count: 0))
    end)

    cart = Repo.get_by(Cart, store_id: store.id) |> Repo.preload(:items)
    assert Enum.count(cart.items) == 0
  end

end
