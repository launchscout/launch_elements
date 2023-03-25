defmodule LaunchCartWeb.FormLive.FormComponent do
  use LaunchCartWeb, :live_component

  alias LaunchCart.Forms

  @impl true
  def update(%{form: form, user_id: user_id} = assigns, socket) do
    changeset = Forms.change_form(form)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"form" => form_params}, socket) do
    changeset =
      socket.assigns.form
      |> Forms.change_form(form_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"form" => form_params}, socket) do
    save_form(socket, socket.assigns.action, form_params)
  end

  defp save_form(socket, :edit, form_params) do
    case Forms.update_form(socket.assigns.form, form_params) do
      {:ok, _form} ->
        {:noreply,
         socket
         |> put_flash(:info, "Form updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_form(%{assigns: %{user_id: user_id}} = socket, :new, form_params) do
    case Forms.create_form(form_params |> Map.put("user_id", user_id)) do
      {:ok, _form} ->
        {:noreply,
         socket
         |> put_flash(:info, "Form created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
