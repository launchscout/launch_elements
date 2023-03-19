defmodule LaunchCartWeb.WebHookLive.Index do
  use LaunchCartWeb, :live_view

  alias LaunchCart.WebHooks
  alias LaunchCart.WebHooks.WebHook

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :web_hooks, list_web_hooks())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Web hook")
    |> assign(:web_hook, WebHooks.get_web_hook!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Web hook")
    |> assign(:web_hook, %WebHook{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Web hooks")
    |> assign(:web_hook, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    web_hook = WebHooks.get_web_hook!(id)
    {:ok, _} = WebHooks.delete_web_hook(web_hook)

    {:noreply, assign(socket, :web_hooks, list_web_hooks())}
  end

  defp list_web_hooks do
    WebHooks.list_web_hooks()
  end
end
