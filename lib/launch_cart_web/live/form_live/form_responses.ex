defmodule LaunchCartWeb.FormLive.FormResponses do
  use LaunchCartWeb, :live_view

  alias LaunchCart.Forms
  alias LaunchCart.Forms.Form


  @impl true
  def mount(_params, _session, socket) do

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do

    {:noreply,
     socket
     |> assign(:form_responses, Forms.get_form_responses!(id))}
  end

end
