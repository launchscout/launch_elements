defmodule LaunchCart.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :author, :string
      add :comment, :text
      add :url, :string
      add :comment_site_id, references(:comment_sites, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:comments, [:comment_site_id])
  end
end
