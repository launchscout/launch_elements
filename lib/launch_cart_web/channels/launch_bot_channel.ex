defmodule LaunchCartWeb.LaunchBotChannel do
  use LiveState.Channel, web_module: LaunchCartWeb

  alias LaunchCart.Bot

  @impl true
  def init("launch_bot:" <> bot_id, _params, _socket) do
    {:ok, %{bot_id: bot_id, conversation: []}}
  end

  # @impl true
  # def handle_event("add_message", %{"text" => text}, %{conversation: messages} = state) do
  #   messages = messages ++ [%{"content" => text, "role" => "user"}]
  #   case OpenAI.chat_completion(model: "gpt-3.5-turbo", messages: messages) do
  #     {:ok, %{choices: [%{"message" => message} | _]}} ->
  #       IO.inspect(messages ++ message)
  #       {:noreply, %{conversation: messages ++ [message]} }
  #     {:error, error} ->
  #       IO.inspect(error)
  #       {:noreply, state}
  #   end
  # end


  # @impl true
  # def handle_event("add_message", %{"text" => text}, %{conversation: messages} = state) do
  #   messages = messages ++ [%{"content" => text, "role" => "user"}]
  #   Bot.stream(messages)
  #   |> Enum.take(1)
  #   |> Enum.each(fn message ->
  #     IO.inspect( messages ++ [%{"content" => message, "role" => "user"}])
  #     # push(socket, "new_message", %{"content" => message})
  #     {:noreply, %{conversation: messages ++ [%{"content" => message, "role" => "user"}]} }
  #   end)
  #   # {:noreply, %{conversation: messages}}
  # end

  # @impl true
  # def handle_event("add_message", %{"text" => text},  %{conversation: messages} = state) do
  #   messages = messages ++ [%{"content" => text, "role" => "user"}]
  #   stream = Bot.stream(messages)
  #   {:noreply, %{conversation: messages ++ [%{"content" => stream_response(stream), "role" => "user"}]} }
  # end

 @impl true
  def handle_event("add_message", %{"text" => text}, %{conversation: messages} = state) do
    messages = [%{"content" => text, "role" => "user"} | messages]
    IO.inspect(Enum.reverse(messages))
    stream = Bot.stream(Enum.reverse(messages))
    messages =  [%{"content" => "", "role" => "assistant"} | messages]
    {:ok, _pid} = LaunchCart.StreamHandler.start_link({self(), stream})

    {:noreply, %{conversation: messages}}
  end

  @impl true
  def handle_message({:render_response_chunk, chunk}, %{conversation: [%{"content" => current_message} | messages ]} = state) do
    current_message = "#{current_message}#{chunk}"
    IO.inspect(current_message)
    {:noreply, %{conversation: [%{"content" => current_message, "role" => "assistant"}  | messages]}}
  end
end
