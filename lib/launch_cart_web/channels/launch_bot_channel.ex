defmodule LaunchCartWeb.LaunchBotChannel do
  use LiveState.Channel, web_module: LaunchCartWeb

  alias LaunchCart.Bot

  @impl true
  def init("launch_bot:" <> bot_id, _params, _socket) do
    {:ok, %{bot_id: bot_id, conversation: []}}
  end

  @impl true
  def handle_event("add_message", %{"text" => text}, %{conversation: messages} = state) do
    messages = messages ++ [%{"content" => text, "role" => "user"}]
    case OpenAI.chat_completion(model: "gpt-3.5-turbo", messages: messages) do
      {:ok, %{choices: [%{"message" => message} | _]}} ->
        IO.inspect(messages ++ message)
        {:noreply, %{conversation: messages ++ [message]} }
      {:error, error} ->
        IO.inspect(error)
        {:noreply, state}
    end
  end

end
