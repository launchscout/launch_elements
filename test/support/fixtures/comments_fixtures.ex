defmodule LaunchCart.CommentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LaunchCart.Comments` context.
  """

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    {:ok, comment} =
      attrs
      |> Enum.into(%{
        author: "some author",
        comment: "some comment",
        url: "some url"
      })
      |> LaunchCart.Comments.create_comment()

    comment
  end
end
