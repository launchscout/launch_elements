defmodule LaunchCart.Stores.Store do
  use Ecto.Schema
  import Ecto.Changeset
  alias LaunchCart.Accounts.User
  alias LaunchCart.StripeAccounts.StripeAccount

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "stores" do
    field :name, :string
    belongs_to :user, User
    belongs_to :stripe_account, StripeAccount

    timestamps()
  end

  @doc false
  def changeset(store, attrs) do
    store
    |> cast(attrs, [:name, :user_id, :stripe_account_id])
    |> validate_required([:name, :user_id])
  end
end
