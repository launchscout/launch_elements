defmodule LaunchCart.FormsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LaunchCart.Forms` context.
  """

  @doc """
  Generate a form.
  """
  def form_fixture(attrs \\ %{}) do
    {:ok, form} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> LaunchCart.Forms.create_form()

    form
  end

  @doc """
  Generate a form_response.
  """
  def form_response_fixture(attrs \\ %{}) do
    {:ok, form_response} =
      attrs
      |> Enum.into(%{
        response: %{}
      })
      |> LaunchCart.Forms.create_form_response()

    form_response
  end
end
