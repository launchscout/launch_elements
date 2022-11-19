defmodule StripeCart.Stores.Store do
  use Ecto.Schema
  import Ecto.Changeset
  alias StripeCart.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "stores" do
    field :name, :string
    field :stripe_customer_id, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(store, attrs) do
    store
    |> cast(attrs, [:name, :stripe_customer_id, :user_id])
    |> validate_required([:name, :stripe_customer_id, :user_id])
  end
end
