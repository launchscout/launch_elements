defmodule LaunchCart.Carts.CartItem do
  use Ecto.Schema
  import Ecto.Changeset
  alias LaunchCart.Carts.Cart

  @derive {Jason.Encoder, except: [:__meta__, :cart]}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "cart_items" do
    field :quantity, :integer
    field :price, :integer
    field :product, :map
    field :stripe_price_id, :string

    belongs_to :cart, Cart

    timestamps()
  end

  @doc false
  def changeset(cart_item, attrs) do
    cart_item
    |> cast(attrs, [:quantity, :cart_id, :product, :stripe_price_id, :price])
    |> validate_required([:quantity, :stripe_price_id, :product, :price])
  end

  def create_changeset(attrs) do
    %__MODULE__{} |> changeset(attrs)
  end
end
