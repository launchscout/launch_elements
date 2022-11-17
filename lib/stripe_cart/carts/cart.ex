defmodule StripeCart.Carts.Cart do

  @derive {Jason.Encoder, except: [:__meta__]}

  use Ecto.Schema
  import Ecto.Changeset

  alias StripeCart.Carts.CartItem

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "carts" do
    has_many :items, CartItem
    timestamps()
  end

  @doc false
  def create_changeset(attrs) do
    %__MODULE__{}
    |> change(attrs)
    |> cast_assoc(:items, with: &CartItem.create_changeset/1)
  end
end
