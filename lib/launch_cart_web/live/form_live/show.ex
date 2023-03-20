defmodule LaunchCartWeb.FormLive.Show do
  use LaunchCartWeb, :live_view

  alias LaunchCart.Forms
  alias LaunchCart.Forms.Form
  alias LaunchCart.WebHooks
  alias LaunchCartWeb.Endpoint

  use LiveElements.CustomElementsHelpers

  custom_element :web_hooks, events: ["save-web-hook"]

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
     |> assign(:form, Forms.get_form!(id))}
  end

  def handle_event("save-web-hook", %{"id" => web_hook_id} = attrs, %{assigns: %{form: %Form{id: form_id}}} = socket) do
    with webhook <- WebHooks.get_web_hook!(web_hook_id),
      {:ok, _saved_web_hook} <- WebHooks.update_web_hook(webhook, attrs) do

      {:noreply, socket
        |> push_event("saved-web-hook", webhook)
        |> assign(:form, Forms.get_form!(form_id))}
    end
  end

  @impl true
  def handle_event("save-web-hook", attrs, %{assigns: %{form: %Form{id: form_id}}} = socket) do
    with {:ok, webhook} <- WebHooks.create_web_hook(attrs |> Map.put("form_id", form_id)) do

      {:noreply, socket
        |> push_event("saved-web-hook", webhook)
        |> assign(:form, Forms.get_form!(form_id))}
    end
  end

  defp page_title(:show), do: "Show Form"
  defp page_title(:edit), do: "Edit Form"
end
