defmodule LaunchCartWeb.CommentSiteLiveTest do
  use LaunchCartWeb.ConnCase

  import Phoenix.LiveViewTest
  import LaunchCart.CommentSitesFixtures
  import LaunchCart.Factory
  alias LaunchCart.Comments
  alias LaunchCart.Comments.Comment

  @create_attrs %{name: "some name", url: "some url"}
  @update_attrs %{name: "some updated name", url: "some updated url"}
  @invalid_attrs %{name: nil, url: nil}

  setup(%{conn: conn}) do
    user = insert(:user)
    conn = log_in_user(conn, user)
    %{user: user, conn: conn}
  end

  defp create_comment_site(%{user: user}) do
    comment_site = insert(:comment_site, user: user)
    %{comment_site: comment_site}
  end

  describe "Index" do
    setup [:create_comment_site]

    test "lists all comment_sites", %{conn: conn, comment_site: comment_site} do
      other_comment_site = insert(:comment_site, name: "Other comment_site")
      {:ok, _index_live, html} = live(conn, Routes.comment_site_index_path(conn, :index))

      assert html =~ "Listing Comment sites"
      assert html =~ comment_site.name
      refute html =~ other_comment_site.name
    end

    # test "saves new form", %{conn: conn} do
    #   {:ok, index_live, _html} = live(conn, Routes.comment_site_index_path(conn, :index))

    #   assert index_live |> element("a", "New Form") |> render_click() =~
    #            "New Form"

    #   assert_patch(index_live, Routes.form_index_path(conn, :new))

    #   assert index_live
    #          |> form("#form-form", form: @invalid_attrs)
    #          |> render_change() =~ "can&#39;t be blank"

    #   {:ok, _, html} =
    #     index_live
    #     |> form("#form-form", form: @create_attrs)
    #     |> render_submit()
    #     |> follow_redirect(conn, Routes.form_index_path(conn, :index))

    #   assert html =~ "Form created successfully"
    #   assert html =~ "some name"
    # end

    test "saves new comment_site", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.comment_site_index_path(conn, :index))

      assert index_live |> element("a", "New Comment Site") |> render_click() =~
               "New Comment site"

      assert_patch(index_live, Routes.comment_site_index_path(conn, :new))

      assert index_live
             |> form("#comment_site-form", comment_site: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#comment_site-form", comment_site: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.comment_site_index_path(conn, :index))

      assert html =~ "Comment site created successfully"
      assert html =~ "some name"
    end

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

  describe "View Comments" do
    setup [:create_comment_site]

    test "can approve comments", %{conn: conn, comment_site: comment_site} do
      comment1 = insert(:comment, comment_site: comment_site, approved: false)
      comment2 = insert(:comment, comment_site: comment_site, approved: false)
      {:ok, show_live, html} = live(conn, Routes.comment_site_comments_path(conn, :index, comment_site))
      assert html =~ comment1.comment
      assert html =~ comment2.comment

      show_live |> element("#approve-comment-#{comment1.id}") |> render_click()

      assert %Comment{approved: true} = Comments.get_comment!(comment1.id)
    end
  end
  describe "Show" do
    setup [:create_comment_site]

    test "displays comment_site", %{conn: conn, comment_site: comment_site} do
      {:ok, _show_live, html} = live(conn, Routes.comment_site_show_path(conn, :show, comment_site))

      assert html =~ comment_site.name
    end

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
  end
end
