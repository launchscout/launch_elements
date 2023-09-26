defmodule LaunchCartWeb.CommentSiteLive.Show do
  use LaunchCartWeb, :live_view

  alias LaunchCart.CommentSites

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:comment_site, CommentSites.get_comment_site!(id))}
  end

  defp page_title(:show), do: "Show Comment site"
  defp page_title(:edit), do: "Edit Comment site"
end
