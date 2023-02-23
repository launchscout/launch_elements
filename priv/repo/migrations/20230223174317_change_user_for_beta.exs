defmodule LaunchCart.Repo.Migrations.ChangeUserForBeta do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :notes, :text
      add :active, :boolean
      modify :hashed_password, :string, null: true
    end
  end
end
