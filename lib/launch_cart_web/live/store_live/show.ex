defmodule LaunchCartWeb.StoreLive.Show do
  use LaunchCartWeb, :live_view

  alias LaunchCartWeb.Endpoint
  alias LaunchCart.Stores

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    wsurl = Endpoint.url() |> String.replace("http:", "ws:") |> String.replace("https:", "wss:")
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:url, "#{wsurl}/socket")
     |> assign(:store, Stores.get_store!(id))}
  end

  defp page_title(:show), do: "Show Store"
  defp page_title(:edit), do: "Edit Store"
end
