defmodule LaunchCart.WebHooksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LaunchCart.WebHooks` context.
  """

  @doc """
  Generate a web_hook.
  """
  def web_hook_fixture(attrs \\ %{}) do
    {:ok, web_hook} =
      attrs
      |> Enum.into(%{
        description: "some description",
        headers: %{},
        url: "some url"
      })
      |> LaunchCart.WebHooks.create_web_hook()

    web_hook
  end
end
