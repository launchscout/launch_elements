defmodule LaunchCartWeb.Features.LaunchCommentsTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias LaunchCart.Repo
  alias LaunchCart.CommentSites
  alias LaunchCart.Comments
  alias LaunchCartWeb.Endpoint
  alias LaunchCartWeb.Router.Helpers, as: Routes

  import Wallaby.Query
  import LaunchCart.Factory

  setup do
    comment_site = insert(:comment_site, requires_approval: false)
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

  feature "comments can require approval", %{session: session} do
    comment_site = insert(:comment_site, requires_approval: true)
    session
    |> visit("/fake_comment_site/#{comment_site.id}")
    |> find(css("launch-comments"))
    |> shadow_root()
    |> assert_has(css("div", text: "Your comments will appear after approval"))
    |> fill_in(css("#author"), with: "Bob")
    |> fill_in(css("#comment"), with: "Has sumpin to say")
    |> click(css("button"))
    |> refute_has(css("div[part='comment-text']", text: "Has sumpin to say"))

    assert %{comments: [%{comment: "Has sumpin to say", author: "Bob", approved: false}]} =
             CommentSites.get_comment_site!(comment_site.id) |> Repo.preload(:comments)
  end

  feature "comments appear as they are approved", %{session: session} do
    comment_site = insert(:comment_site, requires_approval: true)
    session = session
    |> visit("/fake_comment_site/#{comment_site.id}")
    |> find(css("launch-comments"))
    |> shadow_root()
    |> fill_in(css("#author"), with: "Bob")
    |> fill_in(css("#comment"), with: "Has sumpin to say")
    |> click(css("button"))
    |> refute_has(css("div[part='comment-text']", text: "Has sumpin to say"))

    %{comments: [comment]} =
      CommentSites.get_comment_site!(comment_site.id) |> Repo.preload(:comments)
    {:ok, _} = Comments.update_comment(comment, %{approved: true})

    session |> assert_has(css("div[part='comment-text']", text: "Has sumpin to say"))
  end

  feature "sees new comments as they are created", %{session: session, comment_site: comment_site} do
    session =
      session
      |> visit("/fake_comment_site/#{comment_site.id}")

    {:ok, _comment} =
      Comments.create_comment(%{
        comment_site_id: comment_site.id,
        url: Routes.page_url(Endpoint, :fake_comment_site, comment_site.id),
        author: "Yo Mamma",
        comment: "is so great that you are lucky to have her."
      })

    session
    |> find(css("launch-comments"))
    |> shadow_root()
    |> assert_has(css("div[part='comment-text']", text: "is so great"))
  end

  feature "sees comments for current page url only", %{
    session: session,
    comment_site: comment_site
  } do
    session =
      session
      |> visit("/fake_comment_site/#{comment_site.id}")

    {:ok, _comment} =
      Comments.create_comment(%{
        comment_site_id: comment_site.id,
        url: Routes.page_url(Endpoint, :fake_comment_site, comment_site.id),
        author: "Yo Mamma",
        comment: "is so great that you are lucky to have her."
      })

    {:ok, _comment} =
      Comments.create_comment(%{
        comment_site_id: comment_site.id,
        url: "http://foo.bar/dad",
        author: "Yo Daddy",
        comment: "is pretty good."
      })

    session
    |> find(css("launch-comments"))
    |> shadow_root()
    |> assert_has(css("div[part='comment-text']", text: "is so great"))
    |> refute_has(css("div[part='comment-text']", text: "is pretty good"))
  end
end
