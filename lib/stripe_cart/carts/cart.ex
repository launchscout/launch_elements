defmodule StripeCart.Carts.Cart do

  @derive {Jason.Encoder, except: [:__meta__, :store]}

  use Ecto.Schema
  import Ecto.Changeset

  alias StripeCart.Carts.CartItem
  alias StripeCart.Stores.Store

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "carts" do
    has_many :items, CartItem
    belongs_to :store, Store
    timestamps()
  end

  @doc false
  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:store_id])
    |> cast_assoc(:items, with: &CartItem.create_changeset/1)
    |> foreign_key_constraint(:store_id)
  end
end
