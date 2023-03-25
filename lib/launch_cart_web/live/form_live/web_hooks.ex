defmodule LaunchCartWeb.FormLive.WebHooks do
  use LaunchCartWeb, :live_component

  alias LaunchCart.WebHooks
  alias LaunchCart.WebHooks.WebHook

  @impl true
  def update(%{form: form} = assigns, socket) do
    web_hooks = WebHooks.list_web_hooks(form)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:web_hooks, web_hooks)
     |> assign(:page_title, "New Web Hook")
     |> assign(:edit_web_hook, false)
     |> assign(:web_hook, %WebHook{})}
  end

  def handle_event("new", _params, socket) do
    {:noreply, socket |> assign(:edit_web_hook, true)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    web_hook = WebHooks.get_web_hook!(id)
    {:ok, _} = WebHooks.delete_web_hook(web_hook)

    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", %{"web_hook" => web_hook_params}, socket) do
    changeset =
      socket.assigns.web_hook
      |> WebHooks.change_web_hook(web_hook_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"web_hook" => web_hook_params}, socket) do
    save_web_hook(socket, web_hook_params)
  end

  defp save_web_hook(%{assigns: %{web_hook: %WebHook{id: id}}} = socket, web_hook_params)
       when not is_nil(id) do
    case WebHooks.update_web_hook(socket.assigns.web_hook, web_hook_params) do
      {:ok, _web_hook} ->
        send(self(), :reload)

        {:noreply,
         socket
         |> assign(:edit_web_hook, false)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_web_hook(socket, web_hook_params) do
    case WebHooks.create_web_hook(web_hook_params) do
      {:ok, _web_hook} ->
        send(self(), :reload)

        {:noreply,
         socket
         |> assign(:edit_web_hook, false)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
