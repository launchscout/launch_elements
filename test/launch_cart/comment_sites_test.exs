defmodule LaunchCart.CommentSitesTest do
  use LaunchCart.DataCase

  alias LaunchCart.CommentSites

  describe "comment_sites" do
    alias LaunchCart.CommentSites.CommentSite

    import LaunchCart.Factory

    @invalid_attrs %{name: nil, url: nil}

    test "list_comment_sites/0 returns all comment_sites" do
      comment_site = insert(:comment_site)
      assert CommentSites.list_comment_sites() |> Enum.map(& &1.id) == [comment_site.id]
    end

    test "list_comment_sites/1 returns comments for user" do
      user = insert(:user)
      comment_site = insert(:comment_site, user: user)
      other_comment_site = insert(:comment_site)
      assert CommentSites.list_comment_sites(user) |> Enum.map(& &1.id) == [comment_site.id]
    end

    test "get_comment_site!/1 returns the comment_site with given id" do
      comment_site = insert(:comment_site)
      assert CommentSites.get_comment_site!(comment_site.id)
    end

    test "create_comment_site/1 with valid data creates a comment_site" do
      valid_attrs = %{name: "some name", url: "some url"}

      assert {:ok, %CommentSite{} = comment_site} = CommentSites.create_comment_site(valid_attrs)
      assert comment_site.name == "some name"
      assert comment_site.url == "some url"
    end

    test "create_comment_site/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CommentSites.create_comment_site(@invalid_attrs)
    end

    test "update_comment_site/2 with valid data updates the comment_site" do
      comment_site = insert(:comment_site)
      update_attrs = %{name: "some updated name", url: "some updated url"}

      assert {:ok, %CommentSite{} = comment_site} = CommentSites.update_comment_site(comment_site, update_attrs)
      assert comment_site.name == "some updated name"
      assert comment_site.url == "some updated url"
    end

    test "update_comment_site/2 with invalid data returns error changeset" do
      comment_site = insert(:comment_site)
      assert {:error, %Ecto.Changeset{}} = CommentSites.update_comment_site(comment_site, @invalid_attrs)
    end

    test "delete_comment_site/1 deletes the comment_site" do
      comment_site = insert(:comment_site)
      assert {:ok, %CommentSite{}} = CommentSites.delete_comment_site(comment_site)
      assert_raise Ecto.NoResultsError, fn -> CommentSites.get_comment_site!(comment_site.id) end
    end

    test "change_comment_site/1 returns a comment_site changeset" do
      comment_site = insert(:comment_site)
      assert %Ecto.Changeset{} = CommentSites.change_comment_site(comment_site)
    end
  end
end
