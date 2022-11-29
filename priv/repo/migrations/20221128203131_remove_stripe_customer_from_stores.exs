defmodule StripeCart.Repo.Migrations.RemoveStripeCustomerFromStores do
  use Ecto.Migration

  def change do
    alter table(:stores) do
      remove :stripe_customer_id
    end
  end
end
