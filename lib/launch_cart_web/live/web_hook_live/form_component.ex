defmodule LaunchCartWeb.WebHookLive.FormComponent do
  use LaunchCartWeb, :live_component

  alias LaunchCart.WebHooks

  @impl true
  def update(%{web_hook: web_hook} = assigns, socket) do
    changeset = WebHooks.change_web_hook(web_hook)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
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

  defp save_web_hook(socket, :edit, web_hook_params) do
    case WebHooks.update_web_hook(socket.assigns.web_hook, web_hook_params) do
      {:ok, _web_hook} ->
        {:noreply,
         socket
         |> put_flash(:info, "Web hook updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_web_hook(socket, :new, web_hook_params) do
    case WebHooks.create_web_hook(web_hook_params) do
      {:ok, _web_hook} ->
        {:noreply,
         socket
         |> put_flash(:info, "Web hook created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
