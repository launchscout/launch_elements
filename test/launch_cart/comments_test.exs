defmodule LaunchCart.CommentsTest do
  use LaunchCart.DataCase

  alias LaunchCart.Comments

  describe "comments" do
    alias LaunchCart.Comments.Comment

    import LaunchCart.Factory

    @invalid_attrs %{author: nil, comment: nil, url: nil}

    test "list_comments/1 returns all comments for site" do
      comment = insert(:comment)
      assert Comments.list_comments() |> Enum.map(& &1.id) == [comment.id]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = insert(:comment)
      assert Comments.get_comment!(comment.id)
    end

    test "create_comment/1 with valid data creates a comment" do
      valid_attrs = %{author: "some author", comment: "some comment", url: "some url"}

      assert {:ok, %Comment{} = comment} = Comments.create_comment(valid_attrs)
      assert comment.author == "some author"
      assert comment.comment == "some comment"
      assert comment.url == "some url"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Comments.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = insert(:comment)
      update_attrs = %{author: "some updated author", comment: "some updated comment", url: "some updated url"}

      assert {:ok, %Comment{} = comment} = Comments.update_comment(comment, update_attrs)
      assert comment.author == "some updated author"
      assert comment.comment == "some updated comment"
      assert comment.url == "some updated url"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = insert(:comment)
      assert {:error, %Ecto.Changeset{}} = Comments.update_comment(comment, @invalid_attrs)
    end

    test "delete_comment/1 deletes the comment" do
      comment = insert(:comment)
      assert {:ok, %Comment{}} = Comments.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Comments.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = insert(:comment)
      assert %Ecto.Changeset{} = Comments.change_comment(comment)
    end
  end
end
