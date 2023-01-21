defmodule LaunchCartWeb.StoreLive.Index do
  use LaunchCartWeb, :live_view

  alias LaunchCart.Stores
  alias LaunchCart.Stores.Store

  @impl true
  def mount(_params, _session, %{assigns: %{current_user: user}} = socket) do
    {:ok, assign(socket, :stores, list_stores(user))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Store")
    |> assign(:store, Stores.get_store!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Store")
    |> assign(:store, %Store{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Stores")
    |> assign(:store, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id},  %{assigns: %{current_user: user}} = socket) do
    store = Stores.get_store!(id)
    {:ok, _} = Stores.delete_store(store)

    {:noreply, assign(socket, :stores, list_stores(user))}
  end

  defp list_stores(user) do
    Stores.list_stores(user)
  end
end
