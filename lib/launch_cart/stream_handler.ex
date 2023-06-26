defmodule LaunchCart.StreamHandler do
  use GenServer

  def start_link({channel_pid, stream}) do
    GenServer.start_link(__MODULE__, {channel_pid, stream})
  end

  @spec init({any, any}) :: {:ok, %{channel_pid: any}}
  def init({channel_pid, stream}) do
    Task.start_link(fn ->
      for chunk <- stream do
        send(channel_pid, {:render_response_chunk, chunk})
      end
    end)
    {:ok, %{channel_pid: channel_pid}}
  end
end
