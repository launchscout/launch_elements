defmodule StripeCartWeb.Features.TodoListTest do
  alias StripeCart.Test.FakeStripe
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query

  setup do
    products = FakeStripe.populate_cache()
    {:ok, %{products: products}}
  end

  feature "add item", %{session: session} do
    session
    |> visit("/")
    |> assert_text("My Store")
    |> click(css("button#add-price_123"))
    |> within_shadow_dom("stripe-cart", fn shadow_dom ->
      shadow_dom
      |> assert_has(css("sl-badge", text: "1"))
      |> click(css("sl-button"))
      |> assert_has(css("table", text: "babies"))
    end)
  end

  @tag :skip
  feature "add item and reload", %{session: session} do
    session
    |> visit("/")
    |> assert_text("My Store")
    |> click(css("button#add-price_123"))
    |> within_shadow_dom("stripe-cart", fn shadow_dom ->
      shadow_dom
      |> assert_has(css("sl-badge", text: "1"))
    end)
    |> visit("/")
    |> within_shadow_dom("stripe-cart", fn shadow_dom ->
      shadow_dom
      |> assert_has(css("table", text: "babies"))
    end)
  end

end
