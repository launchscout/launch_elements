defmodule LaunchCartWeb.WasmHandlerLiveTest do
  use LaunchCartWeb.ConnCase

  import Phoenix.LiveViewTest
  import LaunchCart.FormsFixtures

  @create_attrs %{wasm: "some wasm"}
  @update_attrs %{wasm: "some updated wasm"}
  @invalid_attrs %{wasm: nil}

  defp create_wasm_handler(_) do
    wasm_handler = wasm_handler_fixture()
    %{wasm_handler: wasm_handler}
  end

  describe "Index" do
    setup [:create_wasm_handler]

    test "lists all wasm_handlers", %{conn: conn, wasm_handler: wasm_handler} do
      {:ok, _index_live, html} = live(conn, ~p"/wasm_handlers")

      assert html =~ "Listing Wasm handlers"
      assert html =~ wasm_handler.wasm
    end

    test "saves new wasm_handler", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/wasm_handlers")

      assert index_live |> element("a", "New Wasm handler") |> render_click() =~
               "New Wasm handler"

      assert_patch(index_live, ~p"/wasm_handlers/new")

      assert index_live
             |> form("#wasm_handler-form", wasm_handler: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#wasm_handler-form", wasm_handler: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/wasm_handlers")

      html = render(index_live)
      assert html =~ "Wasm handler created successfully"
      assert html =~ "some wasm"
    end

    test "updates wasm_handler in listing", %{conn: conn, wasm_handler: wasm_handler} do
      {:ok, index_live, _html} = live(conn, ~p"/wasm_handlers")

      assert index_live |> element("#wasm_handlers-#{wasm_handler.id} a", "Edit") |> render_click() =~
               "Edit Wasm handler"

      assert_patch(index_live, ~p"/wasm_handlers/#{wasm_handler}/edit")

      assert index_live
             |> form("#wasm_handler-form", wasm_handler: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#wasm_handler-form", wasm_handler: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/wasm_handlers")

      html = render(index_live)
      assert html =~ "Wasm handler updated successfully"
      assert html =~ "some updated wasm"
    end

    test "deletes wasm_handler in listing", %{conn: conn, wasm_handler: wasm_handler} do
      {:ok, index_live, _html} = live(conn, ~p"/wasm_handlers")

      assert index_live |> element("#wasm_handlers-#{wasm_handler.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#wasm_handlers-#{wasm_handler.id}")
    end
  end

  describe "Show" do
    setup [:create_wasm_handler]

    test "displays wasm_handler", %{conn: conn, wasm_handler: wasm_handler} do
      {:ok, _show_live, html} = live(conn, ~p"/wasm_handlers/#{wasm_handler}")

      assert html =~ "Show Wasm handler"
      assert html =~ wasm_handler.wasm
    end

    test "updates wasm_handler within modal", %{conn: conn, wasm_handler: wasm_handler} do
      {:ok, show_live, _html} = live(conn, ~p"/wasm_handlers/#{wasm_handler}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Wasm handler"

      assert_patch(show_live, ~p"/wasm_handlers/#{wasm_handler}/show/edit")

      assert show_live
             |> form("#wasm_handler-form", wasm_handler: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#wasm_handler-form", wasm_handler: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/wasm_handlers/#{wasm_handler}")

      html = render(show_live)
      assert html =~ "Wasm handler updated successfully"
      assert html =~ "some updated wasm"
    end
  end
end
