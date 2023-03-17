defmodule LaunchCart.Forms.Form do
  use Ecto.Schema
  import Ecto.Changeset

  alias LaunchCart.Accounts.User
  alias LaunchCart.Forms.FormResponse

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "forms" do
    field :name, :string
    belongs_to :user, User
    has_many :responses, FormResponse

    timestamps()
  end

  @doc false
  def changeset(form, attrs) do
    form
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name, :user_id])
  end
end
