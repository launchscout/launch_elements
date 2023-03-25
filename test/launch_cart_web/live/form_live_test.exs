defmodule LaunchCartWeb.FormLiveTest do
  use LaunchCartWeb.ConnCase

  import Phoenix.LiveViewTest
  import LaunchCart.Factory

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  setup(%{conn: conn}) do
    user = insert(:user)
    conn = log_in_user(conn, user)
    %{user: user, conn: conn}
  end

  defp create_form(%{user: user}) do
    form = insert(:form, user: user)
    %{form: form}
  end

  describe "Index" do
    setup [:create_form]

    test "lists all forms for current user", %{conn: conn, form: form} do
      other_form = insert(:form, name: "Other form")
      {:ok, _index_live, html} = live(conn, Routes.form_index_path(conn, :index))

      assert html =~ "Listing Forms"
      assert html =~ form.name
      refute html =~ other_form.name
    end

    test "saves new form", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.form_index_path(conn, :index))

      assert index_live |> element("a", "New Form") |> render_click() =~
               "New Form"

      assert_patch(index_live, Routes.form_index_path(conn, :new))

      assert index_live
             |> form("#form-form", form: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#form-form", form: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.form_index_path(conn, :index))

      assert html =~ "Form created successfully"
      assert html =~ "some name"
    end

    test "updates form in listing", %{conn: conn, form: form} do
      {:ok, index_live, _html} = live(conn, Routes.form_index_path(conn, :index))

      assert index_live |> element("#form-#{form.id} a", "Edit") |> render_click() =~
               "Edit Form"

      assert_patch(index_live, Routes.form_index_path(conn, :edit, form))

      assert index_live
             |> form("#form-form", form: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#form-form", form: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.form_index_path(conn, :index))

      assert html =~ "Form updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes form in listing", %{conn: conn, form: form} do
      {:ok, index_live, _html} = live(conn, Routes.form_index_path(conn, :index))

      assert index_live |> element("#form-#{form.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#form-#{form.id}")
    end
  end

  describe "Show" do
    setup [:create_form]

    test "displays form", %{conn: conn, form: form} do
      {:ok, _show_live, html} = live(conn, Routes.form_show_path(conn, :show, form))

      assert html =~ "Show Form"
      assert html =~ form.name
    end

    test "updates form within modal", %{conn: conn, form: form} do
      {:ok, show_live, _html} = live(conn, Routes.form_show_path(conn, :show, form))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Form"

      assert_patch(show_live, Routes.form_show_path(conn, :edit, form))

      assert show_live
             |> form("#form-form", form: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#form-form", form: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.form_show_path(conn, :show, form))

      assert html =~ "Form updated successfully"
      assert html =~ "some updated name"
    end
  end
end
