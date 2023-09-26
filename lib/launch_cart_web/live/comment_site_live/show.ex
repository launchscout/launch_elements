defmodule LaunchCartWeb.CommentSiteLive.Show do
  use LaunchCartWeb, :live_view

  alias LaunchCart.CommentSites
  alias LaunchCartWeb.Endpoint

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    wsurl = Endpoint.url() |> String.replace("http:", "ws:") |> String.replace("https:", "wss:")
    {:noreply,
     socket
     |> assign(:url, "#{wsurl}/socket")
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:comment_site, CommentSites.get_comment_site!(id))}
  end

  defp page_title(:show), do: "Show Comment site"
  defp page_title(:edit), do: "Edit Comment site"
end
