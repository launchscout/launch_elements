defmodule LaunchCart.Forms.FormResponse do
  use Ecto.Schema
  import Ecto.Changeset
  alias LaunchCart.Forms.Form

  @foreign_key_type :binary_id
  schema "form_responses" do
    field :response, :map
    belongs_to :form, Form

    timestamps()
  end

  @doc false
  def changeset(form_response, attrs) do
    form_response
    |> cast(attrs, [:response, :form_id])
    |> validate_required([:response, :form_id])
  end
end
