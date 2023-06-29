defmodule LaunchCart.Repo.Migrations.CreateCommentSites do
  use Ecto.Migration

  def change do
    create table(:comment_sites, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :url, :string
      add :user_id, references(:users, on_delete: :nothing, type: :uuid)

      timestamps()
    end
    create index(:comment_sites, [:user_id])
  end
end
