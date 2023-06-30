defmodule LaunchCart.Repo.Migrations.CascadeStoreDelete do
  use Ecto.Migration

  def change do
    drop constraint(:carts, :carts_store_id_fkey)
    drop constraint(:cart_items, :cart_items_cart_id_fkey)

    alter table(:carts) do
      modify :store_id, references(:stores, type: :uuid, on_delete: :delete_all)
    end

    alter table(:cart_items) do
      modify :cart_id, references(:carts, type: :uuid, on_delete: :delete_all)
    end
  end
end
