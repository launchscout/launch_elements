defmodule LaunchCartWeb.WebHookLiveTest do
  use LaunchCartWeb.ConnCase

  import Phoenix.LiveViewTest
  import LaunchCart.WebHooksFixtures

  @create_attrs %{description: "some description", headers: %{}, url: "some url"}
  @update_attrs %{description: "some updated description", headers: %{}, url: "some updated url"}
  @invalid_attrs %{description: nil, headers: nil, url: nil}

  defp create_web_hook(_) do
    web_hook = web_hook_fixture()
    %{web_hook: web_hook}
  end

  describe "Index" do
    setup [:create_web_hook]

    test "lists all web_hooks", %{conn: conn, web_hook: web_hook} do
      {:ok, _index_live, html} = live(conn, Routes.web_hook_index_path(conn, :index))

      assert html =~ "Listing Web hooks"
      assert html =~ web_hook.description
    end

    test "saves new web_hook", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.web_hook_index_path(conn, :index))

      assert index_live |> element("a", "New Web hook") |> render_click() =~
               "New Web hook"

      assert_patch(index_live, Routes.web_hook_index_path(conn, :new))

      assert index_live
             |> form("#web_hook-form", web_hook: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#web_hook-form", web_hook: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.web_hook_index_path(conn, :index))

      assert html =~ "Web hook created successfully"
      assert html =~ "some description"
    end

    test "updates web_hook in listing", %{conn: conn, web_hook: web_hook} do
      {:ok, index_live, _html} = live(conn, Routes.web_hook_index_path(conn, :index))

      assert index_live |> element("#web_hook-#{web_hook.id} a", "Edit") |> render_click() =~
               "Edit Web hook"

      assert_patch(index_live, Routes.web_hook_index_path(conn, :edit, web_hook))

      assert index_live
             |> form("#web_hook-form", web_hook: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#web_hook-form", web_hook: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.web_hook_index_path(conn, :index))

      assert html =~ "Web hook updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes web_hook in listing", %{conn: conn, web_hook: web_hook} do
      {:ok, index_live, _html} = live(conn, Routes.web_hook_index_path(conn, :index))

      assert index_live |> element("#web_hook-#{web_hook.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#web_hook-#{web_hook.id}")
    end
  end

  describe "Show" do
    setup [:create_web_hook]

    test "displays web_hook", %{conn: conn, web_hook: web_hook} do
      {:ok, _show_live, html} = live(conn, Routes.web_hook_show_path(conn, :show, web_hook))

      assert html =~ "Show Web hook"
      assert html =~ web_hook.description
    end

    test "updates web_hook within modal", %{conn: conn, web_hook: web_hook} do
      {:ok, show_live, _html} = live(conn, Routes.web_hook_show_path(conn, :show, web_hook))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Web hook"

      assert_patch(show_live, Routes.web_hook_show_path(conn, :edit, web_hook))

      assert show_live
             |> form("#web_hook-form", web_hook: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#web_hook-form", web_hook: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.web_hook_show_path(conn, :show, web_hook))

      assert html =~ "Web hook updated successfully"
      assert html =~ "some updated description"
    end
  end
end
