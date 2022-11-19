defmodule StripeCartWeb.StoreLive.FormComponent do
  use StripeCartWeb, :live_component

  alias StripeCart.Stores

  @impl true
  def update(%{store: store} = assigns, socket) do
    changeset = Stores.change_store(store)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"store" => store_params}, socket) do
    changeset =
      socket.assigns.store
      |> Stores.change_store(store_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"store" => store_params}, socket) do
    save_store(socket, socket.assigns.action, store_params)
  end

  defp save_store(socket, :edit, store_params) do
    case Stores.update_store(socket.assigns.store, store_params) do
      {:ok, _store} ->
        {:noreply,
         socket
         |> put_flash(:info, "Store updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_store(socket, :new, store_params) do
    case Stores.create_store(store_params) do
      {:ok, _store} ->
        {:noreply,
         socket
         |> put_flash(:info, "Store created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
