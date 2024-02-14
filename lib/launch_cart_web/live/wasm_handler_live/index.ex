defmodule LaunchCartWeb.WasmHandlerLive.Index do
  use LaunchCartWeb, :live_view

  alias LaunchCart.Forms
  alias LaunchCart.Forms.WasmHandler

  import LaunchCartWeb.CoreComponents

  @impl true
  def mount(%{"form_id" => form_id}, _session, socket) do
    {:ok,
     socket
     |> assign(:form_id, form_id)
     |> stream(:wasm_handlers, Forms.list_wasm_handlers(form_id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Wasm handler")
    |> assign(:wasm_handler, Forms.get_wasm_handler!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Wasm handler")
    |> assign(:wasm_handler, %WasmHandler{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Wasm handlers")
    |> assign(:wasm_handler, nil)
  end

  @impl true
  def handle_info({LaunchCartWeb.WasmHandlerLive.FormComponent, {:saved, wasm_handler}}, socket) do
    {:noreply, stream_insert(socket, :wasm_handlers, wasm_handler)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    wasm_handler = Forms.get_wasm_handler!(id)
    {:ok, _} = Forms.delete_wasm_handler(wasm_handler)

    {:noreply, stream_delete(socket, :wasm_handlers, wasm_handler)}
  end
end
