defmodule StripeCartWeb.StripeCartChannelTest do
  use StripeCartWeb.ChannelCase

  setup do
    {:ok, _, socket} =
      StripeCartWeb.UserSocket
      |> socket("user_id", %{some: :assign})
      |> subscribe_and_join(StripeCartWeb.StripeCartChannel, "stripe_cart:new")

    %{socket: socket}
  end

end
