defmodule LaunchCart.Repo.Migrations.AddStripeAccountToStores do
  use Ecto.Migration

  def change do
    alter table(:stores) do
      add :stripe_account_id, references(:stripe_accounts, on_delete: :nothing, type: :uuid)
    end
    create index(:stores, [:stripe_account_id])
  end
end
