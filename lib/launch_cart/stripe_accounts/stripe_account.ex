defmodule LaunchCart.StripeAccounts.StripeAccount do
  use Ecto.Schema
  import Ecto.Changeset

  alias LaunchCart.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "stripe_accounts" do
    field :name, :string
    field :stripe_id, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(stripe_account, attrs) do
    stripe_account
    |> cast(attrs, [:name, :stripe_id, :user_id])
    |> validate_required([:stripe_id, :user_id])
  end
end
