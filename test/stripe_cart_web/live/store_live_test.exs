defmodule StripeCartWeb.StoreLiveTest do
  use StripeCartWeb.ConnCase

  import Phoenix.LiveViewTest
  import StripeCart.Factory

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  setup(%{conn: conn}) do
    user = insert(:user)
    store = insert(:store, user: user)
    stripe_account = insert(:stripe_account)
    conn = log_in_user(conn, user)
    %{store: store, user: user, conn: conn, stripe_account: stripe_account}
  end

  describe "Index" do
    test "lists stores for current user", %{conn: conn, store: store} do
      other_store = insert(:store, name: "Not this one")

      {:ok, _index_live, html} = live(conn, Routes.store_index_path(conn, :index))

      assert html =~ "Listing Stores"
      assert html =~ store.name
      refute html =~ other_store.name
    end

    test "saves new store", %{conn: conn, stripe_account: stripe_account} do
      {:ok, index_live, _html} = live(conn, Routes.store_index_path(conn, :index))

      assert index_live |> element("a", "Create a Store") |> render_click() =~
               "New Store"

      assert_patch(index_live, Routes.store_index_path(conn, :new))

      assert index_live
             |> form("#store-form", store: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#store-form", store: @create_attrs)
        |> render_submit(%{stripe_account_id: stripe_account.id})
        |> follow_redirect(conn)

      assert html =~ "Store created successfully"
      assert html =~ "some name"
    end

    test "updates store in listing", %{conn: conn, store: store, stripe_account: stripe_account} do
      {:ok, index_live, _html} = live(conn, Routes.store_index_path(conn, :index))

      assert index_live |> element("#store-#{store.id} a", "Edit") |> render_click() =~
               "Edit Store"

      assert_patch(index_live, Routes.store_index_path(conn, :edit, store))

      assert index_live
             |> form("#store-form", store: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#store-form", store: @update_attrs)
        |> render_submit(%{stripe_account_id: stripe_account.id})
        |> follow_redirect(conn, Routes.store_index_path(conn, :index))

      assert html =~ "Store updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes store in listing", %{conn: conn, store: store} do
      {:ok, index_live, _html} = live(conn, Routes.store_index_path(conn, :index))

      assert index_live |> element("#store-#{store.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#store-#{store.id}")
    end
  end

  describe "Show" do

    test "displays store", %{conn: conn, store: store} do
      {:ok, _show_live, html} = live(conn, Routes.store_show_path(conn, :show, store))

      assert html =~ "Show Store"
      assert html =~ store.name
    end

    test "updates store within modal", %{conn: conn, store: store} do
      {:ok, show_live, _html} = live(conn, Routes.store_show_path(conn, :show, store))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Store"

      assert_patch(show_live, Routes.store_show_path(conn, :edit, store))

      assert show_live
             |> form("#store-form", store: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#store-form", store: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.store_show_path(conn, :show, store))

      assert html =~ "Store updated successfully"
      assert html =~ "some updated name"
    end
  end
end
