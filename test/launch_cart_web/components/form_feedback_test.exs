defmodule LaunchCartWeb.FormFeedbackTest do
  use ExUnit.Case, async: true

  import Phoenix.Component, only: [to_form: 1]
  import Phoenix.LiveViewTest

  alias LaunchCart.Forms.Form
  alias LaunchCartWeb.{CoreComponents, ErrorHelpers}

  test "hides validation errors for inputs the user has not used" do
    form = validation_form(%{"name" => "", "_unused_name" => ""})

    assert ErrorHelpers.error_tag(form, :name) == []
    refute render_component(&CoreComponents.input/1, field: form[:name]) =~ "can&#39;t be blank"
  end

  test "shows validation errors after the user uses an input" do
    form = validation_form(%{"name" => ""})

    assert error_html(form, :name) =~ "can&#39;t be blank"
    assert render_component(&CoreComponents.input/1, field: form[:name]) =~ "can&#39;t be blank"
  end

  test "shows errors on submitted virtual fields outside changeset params" do
    form =
      %LaunchCart.Accounts.User{}
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.add_error(:current_password, "is not valid")
      |> Map.put(:action, :update)
      |> to_form()

    assert error_html(form, :current_password) =~ "is not valid"
  end

  defp validation_form(params) do
    %Form{}
    |> Ecto.Changeset.cast(params, [:name])
    |> Ecto.Changeset.validate_required([:name])
    |> Map.put(:action, :validate)
    |> to_form()
  end

  defp error_html(form, field) do
    form
    |> ErrorHelpers.error_tag(field)
    |> Phoenix.HTML.Safe.to_iodata()
    |> IO.iodata_to_binary()
  end
end
