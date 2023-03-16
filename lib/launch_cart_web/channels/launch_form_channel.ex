defmodule LaunchCartWeb.LaunchFormChannel do
  use LiveState.Channel, web_module: LaunchCartWeb

  def init("launch_form:" <> _form_id, _params, _socket) do
    {:ok, %{}}
  end

  def handle_event(
        "launch-form-submit",
        form_data,
        _state
      ) do
    IO.inspect(form_data)
    {:noreply, %{complete: true}}
  end
end
