defmodule LaunchCartWeb.FormLive.Show do
  use LaunchCartWeb, :live_view

  alias LaunchCart.Forms

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:form, Forms.get_form!(id))}
  end

  defp page_title(:show), do: "Show Form"
  defp page_title(:edit), do: "Edit Form"
end
