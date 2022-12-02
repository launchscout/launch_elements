require Protocol
Protocol.derive(Jason.Encoder, Stripe.Session, only: [:id, :status, :url])
defmodule StripeCart.Carts.Cart do

  @derive {Jason.Encoder, except: [:__meta__, :store]}

  use Ecto.Schema
  import Ecto.Changeset

  alias StripeCart.Carts.CartItem
  alias StripeCart.Stores.Store

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "carts" do
    field :status, Ecto.Enum, values: [:open, :checkout_started, :checkout_complete], default: :open
    field :checkout_session, :map
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

  def checkout_changeset(cart, checkout_session) do
    cart
    |> cast(%{status: status_for(checkout_session), checkout_session: checkout_session}, [:status, :checkout_session])
  end

  defp status_for(%Stripe.Session{status: "open"}), do: :checkout_started
  defp status_for(%Stripe.Session{status: "complete"}), do: :checkout_complete
end
