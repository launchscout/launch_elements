defmodule LaunchCartWeb.Features.LaunchCommentsTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias LaunchCart.Repo
  alias LaunchCart.CommentSites

  import Wallaby.Query
  import LaunchCart.Factory

  setup do
    comment_site = insert(:comment_site)
    {:ok, %{comment_site: comment_site}}
  end

  feature "adds a comment", %{session: session, comment_site: comment_site} do
    session
    |> visit("/fake_comment_site/#{comment_site.id}")
    |> find(css("launch-comments"))
    |> shadow_root()
    |> fill_in(css("#author"), with: "Bob")
    |> fill_in(css("#comment"), with: "Has sumpin to say")
    |> click(css("button"))
    |> assert_has(css("div[part='comment-text']", text: "Has sumpin to say"))

    assert %{comments: [%{comment: "Has sumpin to say", author: "Bob"}]} =
             CommentSites.get_comment_site!(comment_site.id) |> Repo.preload(:comments)
  end
end
