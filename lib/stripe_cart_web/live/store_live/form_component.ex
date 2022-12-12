defmodule StripeCartWeb.StoreLive.FormComponent do
  use StripeCartWeb, :live_component

  alias StripeCart.StripeAccounts
  alias StripeCart.Stores

  @impl true
  def update(%{store: store, user_id: user_id} = assigns, socket) do
    changeset = Stores.change_store(store)
    stripe_accounts = StripeAccounts.list_stripe_accounts(user_id) |> Enum.map(& {&1.name, &1.id})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:stripe_accounts, stripe_accounts)}
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

  defp save_store(%{assigns: %{user_id: user_id}} = socket, :new, store_params) do
    case Stores.create_store(store_params |> Map.put("user_id", user_id)) do
      {:ok, store} ->
        {:noreply,
         socket
         |> put_flash(:info, "Store created successfully")
         |> push_redirect(to: Routes.store_show_path(socket, :show, store))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
