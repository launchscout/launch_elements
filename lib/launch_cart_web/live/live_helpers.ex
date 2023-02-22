defmodule LaunchCartWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias Phoenix.LiveView.JS

  @doc """
  Renders a live component inside a modal.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <.modal return_to={Routes.store_index_path(@socket, :index)}>
        <.live_component
          module={LaunchCartWeb.StoreLive.FormComponent}
          id={@store.id || :new}
          title={@page_title}
          action={@live_action}
          return_to={Routes.store_index_path(@socket, :index)}
          store: @store
        />
      </.modal>
  """
  def modal(assigns) do
    assigns = assign_new(assigns, :return_to, fn -> nil end)

    ~H"""
    <div id="modal" class="modal fade-in" phx-remove={hide_modal()}>
      <div
        id="modal-content"
        class="modal__content fade-in-scale"
        phx-click-away={JS.dispatch("click", to: "#close")}
        phx-window-keydown={JS.dispatch("click", to: "#close")}
        phx-key="escape"
      >
        <%= if @return_to do %>
          <%= live_patch "✖",
            to: @return_to,
            id: "close",
            class: "modal__close",
            phx_click: hide_modal()
          %>
        <% else %>
          <a id="close" href="#" class="modal__close" phx-click={hide_modal()}>✖</a>
        <% end %>

        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  defp hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(to: "#modal", transition: "fade-out")
    |> JS.hide(to: "#modal-content", transition: "fade-out-scale")
  end

  def flash_message(%{flashes: flashes} = assigns) do
    ~H"""
      <%= for {type, message} <- flashes do %>
       <p class={"alert alert--#{type}"}>
        <%= message %>
       </p>
      <% end %>
    """
  end
end
