defmodule StripeCart.Repo.Migrations.CreateCarts do
  use Ecto.Migration

  def change do
    create table(:carts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      timestamps()
    end

    create table(:cart_items, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :price, :integer
      add :quantity, :integer
      add :product, :map
      add :stripe_price_id, :string
      add :cart_id, references(:carts, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:cart_items, [:cart_id])
  end
end
