defmodule LaunchCartWeb.CommentsChannel do
  use LiveState.Channel, web_module: LaunchCartWeb

  alias LaunchCart.Comments
  alias LaunchCart.CommentSites
  alias LaunchCart.CommentSites.CommentSite
  alias LiveState.Event

  @impl true
  def state_key, do: :state

  @impl true
  @spec init(any, any, any) :: {:ok, map()}
  def init("launch_comments:" <> comment_site_id, %{"url" => url}, _socket) do
    Phoenix.PubSub.subscribe(LaunchCart.PubSub, "comments:#{comment_site_id}")

    with %CommentSite{requires_approval: requires_approval} <-
           CommentSites.get_comment_site!(comment_site_id),
         comments <- Comments.list_comments(comment_site_id, url) do
      {:ok, %{comments: comments, url: url, requires_approval: requires_approval} }
    else
      nil -> {:error, "Comment site not found"}
    end
  end

  @impl true
  def handle_event("add_comment", comment_params, state) do
    case Comments.create_comment(comment_params) do
      {:ok, comment} -> {:reply, [%Event{name: "comment_added", detail: comment}], state}
    end
  end

  @impl true
  def handle_message({:comment_created, comment}, %{url: url} = state) do
    {:noreply, state |> Map.put(:comments, Comments.list_comments(comment.comment_site_id, url))}
  end

  @impl true
  def handle_message({:comment_updated, comment}, %{url: url} = state) do
    {:noreply, state |> Map.put(:comments, Comments.list_comments(comment.comment_site_id, url))}
  end

  @impl true
  def handle_message(_message, state), do: {:noreply, state}
end
