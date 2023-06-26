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
  require Logger

  def stream(messages) do
    url = "https://api.openai.com/v1/chat/completions"
    body = Jason.encode!(body(messages, true))
    headers = headers()

    Stream.resource(
      fn -> HTTPoison.post!(url, body, headers, stream_to: self(), async: :once) end,
      &handle_async_response/1,
      &close_async_response/1
    )
  end

  defp close_async_response(resp) do
    :hackney.stop_async(resp)
  end

  defp handle_async_response({:done, resp}) do
    {:halt, resp}
  end

  defp handle_async_response(%HTTPoison.AsyncResponse{id: id} = resp) do
    receive do
      %HTTPoison.AsyncStatus{id: ^id, code: code} ->
        Logger.info("openai,request,status,#{inspect(code)}")
        HTTPoison.stream_next(resp)
        {[], resp}

      %HTTPoison.AsyncHeaders{id: ^id, headers: headers} ->
        Logger.info("openai,request,headers,#{inspect(headers)}")
        HTTPoison.stream_next(resp)
        {[], resp}

      %HTTPoison.AsyncChunk{id: ^id, chunk: chunk} ->
        HTTPoison.stream_next(resp)
        parse_chunk(chunk, resp)

      %HTTPoison.AsyncEnd{id: ^id} ->
        {:halt, resp}
    end
  end

  defp parse_chunk(chunk, resp) do
    {chunk, done?} =
      chunk
      |> String.split("data:")
      |> Enum.map(&String.trim/1)
      |> Enum.reject(&(&1 == ""))
      |> Enum.reduce({"", false}, fn trimmed, {chunk, is_done?} ->
        case Jason.decode(trimmed) do
          {:ok, res} ->
            IO.inspect(res, label: "openai,response")
            delta = List.first(res["choices"])["delta"]
            content = Map.get(delta, "content") || ""
            {chunk <> content, is_done? or false}

          {:error, %{data: "[DONE]"}} ->
            {chunk, is_done? or true}
        end
      end)

    if done? do
      {[chunk], {:done, resp}}
    else
      {[chunk], resp}
    end
  end

  defp headers() do
    [
      Accept: "application/json",
      "Content-Type": "application/json",
      Authorization: "Bearer #{System.get_env("OPENAI_API_KEY")}"
    ]
  end

  defp body(messages, streaming?) do
    %{
      model: "gpt-3.5-turbo",
      messages: messages,
      stream: streaming?,
      max_tokens: 1024
    }
  end
end
