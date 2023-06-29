defmodule LaunchCartWeb.CommentsChannel do
  use LiveState.Channel, web_module: LaunchCartWeb

  alias LaunchCart.Comments
  alias LaunchCart.CommentSites
  alias LaunchCart.CommentSites.CommentSite
  alias LiveState.Event

  @impl true
  def state_key, do: :state

  @impl true
  @spec init(any, any, any) :: {:ok, %{comments: any}}
  def init("launch_comments:" <> comment_site_id, _params, _socket) do
    Phoenix.PubSub.subscribe(LaunchCart.PubSub, "comments:#{comment_site_id}")
    case CommentSites.get_comment_site!(comment_site_id) do
      nil -> {:error, "Comment site not found"}
      %CommentSite{comments: comments} ->
        {:ok, %{comments: comments}}
    end
  end

  @impl true
  def handle_event("add_comment", comment_params, %{comments: comments} = state) do
    case Comments.create_comment(comment_params) do
      {:ok, comment} ->
        new_state = Map.put(state, :comments, comments ++ [comment])
        {:reply, [%Event{name: "comment_added", detail: comment}], new_state}
    end
  end

  @impl true
  def handle_message({:comment_created, comment}, state) do
    {:noreply, state |> Map.put(:comments, Comments.list_comments(comment.comment_site_id))}
  end
end
