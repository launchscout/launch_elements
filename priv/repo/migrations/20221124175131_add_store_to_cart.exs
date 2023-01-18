defmodule LaunchCart.Repo.Migrations.AddStoreToCart do
  use Ecto.Migration

  def change do
    alter table(:carts) do
      add :store_id, references(:stores, on_delete: :nothing, type: :uuid)
    end

    create index(:carts, [:store_id])
  end
end
