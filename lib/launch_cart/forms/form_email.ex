defmodule LaunchCart.Forms.FormEmail do
  use Ecto.Schema
  import Ecto.Changeset

  alias LaunchCart.Forms.Form

  @foreign_key_type :binary_id
  schema "form_emails" do
    field :content, :string
    field :email, :string
    field :subject, :string
    belongs_to :form, Form

    timestamps()
  end

  @doc false
  def changeset(form_email, attrs) do
    form_email
    |> cast(attrs, [:email, :subject, :content])
    |> validate_required([:email])
  end
end
