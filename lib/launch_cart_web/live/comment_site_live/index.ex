defmodule LaunchCartWeb.CommentSiteLive.Index do
  use LaunchCartWeb, :live_view

  alias LaunchCart.CommentSites
  alias LaunchCart.CommentSites.CommentSite


  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :comment_sites, CommentSites.list_comment_sites())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Comment site")
    |> assign(:comment_site, CommentSites.get_comment_site!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Comment site")
    |> assign(:comment_site, %CommentSite{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Comment sites")
    |> assign(:comment_site, nil)
  end

  @impl true
  def handle_info({LaunchCartWeb.CommentSiteLive.FormComponent, {:saved, comment_site}}, socket) do
    {:noreply, stream_insert(socket, :comment_sites, comment_site)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    comment_site = CommentSites.get_comment_site!(id)
    {:ok, _} = CommentSites.delete_comment_site(comment_site)

    {:noreply, stream_delete(socket, :comment_sites, comment_site)}
  end
end
