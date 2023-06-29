defmodule LaunchCart.CommentSitesTest do
  use LaunchCart.DataCase

  alias LaunchCart.CommentSites

  describe "comment_sites" do
    alias LaunchCart.CommentSites.CommentSite

    import LaunchCart.CommentSitesFixtures

    @invalid_attrs %{name: nil, url: nil}

    test "list_comment_sites/0 returns all comment_sites" do
      comment_site = comment_site_fixture()
      assert CommentSites.list_comment_sites() == [comment_site]
    end

    test "get_comment_site!/1 returns the comment_site with given id" do
      comment_site = comment_site_fixture()
      assert CommentSites.get_comment_site!(comment_site.id) == comment_site
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
      comment_site = comment_site_fixture()
      update_attrs = %{name: "some updated name", url: "some updated url"}

      assert {:ok, %CommentSite{} = comment_site} = CommentSites.update_comment_site(comment_site, update_attrs)
      assert comment_site.name == "some updated name"
      assert comment_site.url == "some updated url"
    end

    test "update_comment_site/2 with invalid data returns error changeset" do
      comment_site = comment_site_fixture()
      assert {:error, %Ecto.Changeset{}} = CommentSites.update_comment_site(comment_site, @invalid_attrs)
      assert comment_site == CommentSites.get_comment_site!(comment_site.id)
    end

    test "delete_comment_site/1 deletes the comment_site" do
      comment_site = comment_site_fixture()
      assert {:ok, %CommentSite{}} = CommentSites.delete_comment_site(comment_site)
      assert_raise Ecto.NoResultsError, fn -> CommentSites.get_comment_site!(comment_site.id) end
    end

    test "change_comment_site/1 returns a comment_site changeset" do
      comment_site = comment_site_fixture()
      assert %Ecto.Changeset{} = CommentSites.change_comment_site(comment_site)
    end
  end
end
