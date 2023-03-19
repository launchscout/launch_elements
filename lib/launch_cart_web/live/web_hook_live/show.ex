defmodule LaunchCartWeb.WebHookLive.Show do
  use LaunchCartWeb, :live_view

  alias LaunchCart.WebHooks

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:web_hook, WebHooks.get_web_hook!(id))}
  end

  defp page_title(:show), do: "Show Web hook"
  defp page_title(:edit), do: "Edit Web hook"
end
