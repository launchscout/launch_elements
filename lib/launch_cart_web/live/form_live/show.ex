defmodule LaunchCartWeb.FormLive.Show do
  use LaunchCartWeb, :live_view

  alias LaunchCart.Forms
  alias LaunchCart.Forms.Form
  alias LaunchCart.WebHooks
  alias LaunchCartWeb.Endpoint

  use LiveElements.CustomElementsHelpers

  custom_element(:web_hooks, events: ["save-web-hook", "delete-web-hook"])
  custom_element(:form_emails, events: ["save-form-email", "delete-form-email"])

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

  def handle_event(
        "save-web-hook",
        %{"id" => web_hook_id} = attrs,
        %{assigns: %{form: %Form{id: form_id}}} = socket
      ) do
    with webhook <- WebHooks.get_web_hook!(web_hook_id),
         {:ok, _saved_web_hook} <- WebHooks.update_web_hook(webhook, attrs) do
      {:noreply,
       socket
       |> push_event("saved-web-hook", webhook)
       |> assign(:form, Forms.get_form!(form_id))}
    end
  end

  @impl true
  def handle_event("save-web-hook", attrs, %{assigns: %{form: %Form{id: form_id}}} = socket) do
    with {:ok, webhook} <- WebHooks.create_web_hook(attrs |> Map.put("form_id", form_id)) do
      {:noreply,
       socket
       |> push_event("saved-web-hook", webhook)
       |> assign(:form, Forms.get_form!(form_id))}
    end
  end

  def handle_event(
        "save-form-email",
        %{"id" => form_email_id} = attrs,
        %{assigns: %{form: %Form{id: form_id}}} = socket
      ) do
    with webhook <- Forms.get_form_email!(form_email_id),
         {:ok, _saved_form_email} <- Forms.update_form_email(webhook, attrs) do
      {:noreply,
       socket
       |> push_event("saved-form-email", webhook)
       |> assign(:form, Forms.get_form!(form_id))}
    end
  end

  @impl true
  def handle_event("save-form-email", attrs, %{assigns: %{form: %Form{id: form_id}}} = socket) do
    with {:ok, webhook} <- Forms.create_form_email(attrs |> Map.put("form_id", form_id)) do
      {:noreply,
       socket
       |> push_event("saved-form-email", webhook)
       |> assign(:form, Forms.get_form!(form_id))}
    end
  end

  @impl true
  def handle_event(
        "delete-form-email",
        %{"id" => form_email_id},
        %{assigns: %{form: %Form{id: form_id}}} = socket
      ) do
    with form_email <- Forms.get_form_email!(form_email_id),
         {:ok, deleted} <- Forms.delete_form_email(form_email) do
      {:noreply,
       socket
       |> push_event("saved-form-email", deleted)
       |> assign(:form, Forms.get_form!(form_id))}
    end
  end

  @impl true
  def handle_event(
        "delete-web-hook",
        %{"id" => web_hook_id},
        %{assigns: %{form: %Form{id: form_id}}} = socket
      ) do
    with web_hook <- WebHooks.get_web_hook!(web_hook_id),
         {:ok, deleted} <- WebHooks.delete_web_hook(web_hook) do
      {:noreply,
       socket
       |> push_event("saved-form-email", deleted)
       |> assign(:form, Forms.get_form!(form_id))}
    end
  end

  defp page_title(:show), do: "Show Form"
  defp page_title(:edit), do: "Edit Form"
end
