defmodule LaunchCart.Repo.Migrations.CreateStripeAccounts do
  use Ecto.Migration

  def change do
    create table(:stripe_accounts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :stripe_id, :string
      add :user_id, references(:users, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:stripe_accounts, [:user_id])
  end
end
