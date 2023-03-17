defmodule LaunchCartWeb.LaunchFormChannel do
  use LiveState.Channel, web_module: LaunchCartWeb

  alias LaunchCart.Forms

  def init("launch_form:" <> form_id, _params, _socket) do
    {:ok, %{form_id: form_id}}
  end

  def handle_event(
        "launch-form-submit",
        form_data,
        %{form_id: form_id}
      ) do
    IO.inspect(form_data)

    with {:ok, _form_response} <-
           Forms.create_form_response(%{form_id: form_id, response: form_data}) do
      {:noreply, %{complete: true}}
    end
  end
end
