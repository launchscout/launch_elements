defmodule LaunchCart.StoresFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LaunchCart.Stores` context.
  """

  @doc """
  Generate a store.
  """
  def store_fixture(attrs \\ %{}) do
    {:ok, store} =
      attrs
      |> Enum.into(%{
        name: "some name",
        stripe_customer_id: "some stripe_customer_id"
      })
      |> LaunchCart.Stores.create_store()

    store
  end
end
