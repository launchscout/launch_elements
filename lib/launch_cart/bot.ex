example_message = {:ok,
%{
  choices: [
    %{
      "finish_reason" => "stop",
      "index" => 0,
      "message" => %{
        "content" => "The maximum runway length at Butler County Airport (KHAO) is 5,000 feet.",
        "role" => "assistant"
      }
    }
  ],
  created: 1684089842,
  id: "chatcmpl-7GAzKmrOqljU1X96BRUPVcDceBeVW",
  model: "gpt-3.5-turbo-0301",
  object: "chat.completion",
  usage: %{
    "completion_tokens" => 20,
    "prompt_tokens" => 24,
    "total_tokens" => 44
  }
}}
defmodule LaunchCart.Bot do
  require HTTPoison

  @api_url "https://api.openai.com/v1/chat/completions"

  def api_key do
    System.get_env("OPENAI_API_KEY")
  end

  def chat_with_openai(state, message) do
  end

  def transform_state(state, current_string) do
    state
    |> Enum.map(fn comment ->
      %{
        "role" => (comment.author == "assistant" && "assistant") || "user",
        "content" => comment.text
      }
    end)
    |> List.insert_at(-1, %{"role" => "user", "content" => current_string})
  end
end
