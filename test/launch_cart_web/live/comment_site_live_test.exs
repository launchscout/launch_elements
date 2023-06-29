defmodule LaunchCartWeb.CommentSiteLiveTest do
  use LaunchCartWeb.ConnCase

  import Phoenix.LiveViewTest
  import LaunchCart.CommentSitesFixtures
  import LaunchCart.Factory

  @create_attrs %{name: "some name", url: "some url"}
  @update_attrs %{name: "some updated name", url: "some updated url"}
  @invalid_attrs %{name: nil, url: nil}

  setup(%{conn: conn}) do
    user = insert(:user)
    conn = log_in_user(conn, user)
    %{user: user, conn: conn}
  end

  defp create_comment_site(_) do
    comment_site = comment_site_fixture()
    %{comment_site: comment_site}
  end

  describe "Index" do
    setup [:create_comment_site]

    test "lists all comment_sites", %{conn: conn, comment_site: comment_site} do
      {:ok, _index_live, html} = live(conn, Routes.comment_site_index_path(conn, :index))

      assert html =~ "Listing Comment sites"
      assert html =~ comment_site.name
    end

  #   test "saves new comment_site", %{conn: conn} do
  #     {:ok, index_live, _html} = live(conn, Routes.comment_site_index_path(conn, :index))

  #     assert index_live |> element("a", "New Comment site") |> render_click() =~
  #              "New Comment site"

  #     assert_patch(index_live, ~p"/comment_sites/new")

  #     assert index_live
  #            |> form("#comment_site-form", comment_site: @invalid_attrs)
  #            |> render_change() =~ "can&#39;t be blank"

  #     assert index_live
  #            |> form("#comment_site-form", comment_site: @create_attrs)
  #            |> render_submit()

  #     assert_patch(index_live, ~p"/comment_sites")

  #     html = render(index_live)
  #     assert html =~ "Comment site created successfully"
  #     assert html =~ "some name"
  #   end

  #   test "updates comment_site in listing", %{conn: conn, comment_site: comment_site} do
  #     {:ok, index_live, _html} = live(conn, ~p"/comment_sites")

  #     assert index_live |> element("#comment_sites-#{comment_site.id} a", "Edit") |> render_click() =~
  #              "Edit Comment site"

  #     assert_patch(index_live, ~p"/comment_sites/#{comment_site}/edit")

  #     assert index_live
  #            |> form("#comment_site-form", comment_site: @invalid_attrs)
  #            |> render_change() =~ "can&#39;t be blank"

  #     assert index_live
  #            |> form("#comment_site-form", comment_site: @update_attrs)
  #            |> render_submit()

  #     assert_patch(index_live, ~p"/comment_sites")

  #     html = render(index_live)
  #     assert html =~ "Comment site updated successfully"
  #     assert html =~ "some updated name"
  #   end

  #   test "deletes comment_site in listing", %{conn: conn, comment_site: comment_site} do
  #     {:ok, index_live, _html} = live(conn, ~p"/comment_sites")

  #     assert index_live |> element("#comment_sites-#{comment_site.id} a", "Delete") |> render_click()
  #     refute has_element?(index_live, "#comment_sites-#{comment_site.id}")
  #   end
  end

  # describe "Show" do
  #   setup [:create_comment_site]

  #   test "displays comment_site", %{conn: conn, comment_site: comment_site} do
  #     {:ok, _show_live, html} = live(conn, ~p"/comment_sites/#{comment_site}")

  #     assert html =~ "Show Comment site"
  #     assert html =~ comment_site.name
  #   end

  #   test "updates comment_site within modal", %{conn: conn, comment_site: comment_site} do
  #     {:ok, show_live, _html} = live(conn, ~p"/comment_sites/#{comment_site}")

  #     assert show_live |> element("a", "Edit") |> render_click() =~
  #              "Edit Comment site"

  #     assert_patch(show_live, ~p"/comment_sites/#{comment_site}/show/edit")

  #     assert show_live
  #            |> form("#comment_site-form", comment_site: @invalid_attrs)
  #            |> render_change() =~ "can&#39;t be blank"

  #     assert show_live
  #            |> form("#comment_site-form", comment_site: @update_attrs)
  #            |> render_submit()

  #     assert_patch(show_live, ~p"/comment_sites/#{comment_site}")

  #     html = render(show_live)
  #     assert html =~ "Comment site updated successfully"
  #     assert html =~ "some updated name"
  #   end
  # end
end
