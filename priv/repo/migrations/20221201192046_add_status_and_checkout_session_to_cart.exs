defmodule LaunchCart.Repo.Migrations.AddStatusAndCheckoutSessionToCart do
  use Ecto.Migration

  def change do
    alter table(:carts) do
      add :status, :string
      add :checkout_session, :map
    end
  end
end
