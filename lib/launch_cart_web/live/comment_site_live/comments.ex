defmodule LaunchCartWeb.CommentSiteLive.Comments do
  use LaunchCartWeb, :live_view

  alias LaunchCart.CommentSites
  alias LaunchCart.Comments

  @impl true
  def mount(_params, _session, %{assigns: %{current_user: user}} = socket) do
    {:ok, assign(socket, :comment_sites, CommentSites.list_comment_sites(user))}
  end

  @impl true
  def handle_params(%{"id" => comment_site_id}, _url, socket) do
    {:noreply, socket |> assign(:comments, Comments.list_comments(comment_site_id))}
  end

  @impl true
  def handle_event("approve_comment", %{"comment_id" => comment_id}, socket) do
    with comment <- Comments.get_comment!(comment_id),
         {:ok, _comment} <- Comments.update_comment(comment, %{approved: !comment.approved}) do
      {:noreply, socket}
    end
  end
end
