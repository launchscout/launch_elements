defmodule LaunchCart.Repo.Migrations.RemoveLaunchCustomerFromStores do
  use Ecto.Migration

  def change do
    alter table(:stores) do
      remove :stripe_customer_id
    end
  end
end
