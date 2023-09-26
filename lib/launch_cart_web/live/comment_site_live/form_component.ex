defmodule LaunchCartWeb.CommentSiteLive.FormComponent do
  use LaunchCartWeb, :live_component

  alias LaunchCart.CommentSites


  @impl true
  def update(%{comment_site: comment_site} = assigns, socket) do
    changeset = CommentSites.change_comment_site(comment_site)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"comment_site" => comment_site_params}, socket) do
    changeset =
      socket.assigns.comment_site
      |> CommentSites.change_comment_site(comment_site_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"comment_site" => comment_site_params}, socket) do
    save_comment_site(socket, socket.assigns.action, comment_site_params)
  end

  defp save_comment_site(socket, :edit, comment_site_params) do
    case CommentSites.update_comment_site(socket.assigns.comment_site, comment_site_params) do
      {:ok, comment_site} ->

        {:noreply,
         socket
         |> put_flash(:info, "Comment site updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_comment_site(%{assigns: %{user_id: user_id}} = socket, :new, comment_site_params) do
    case CommentSites.create_comment_site(comment_site_params |> Map.put("user_id", user_id)) do
      {:ok, comment_site} ->

        {:noreply,
         socket
         |> put_flash(:info, "Comment site created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
