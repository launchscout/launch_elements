defmodule LaunchCart.CommentSitesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LaunchCart.CommentSites` context.
  """

  @doc """
  Generate a comment_site.
  """
  def comment_site_fixture(attrs \\ %{}) do
    {:ok, comment_site} =
      attrs
      |> Enum.into(%{
        name: "some name",
        url: "some url"
      })
      |> LaunchCart.CommentSites.create_comment_site()

    comment_site
  end
end
