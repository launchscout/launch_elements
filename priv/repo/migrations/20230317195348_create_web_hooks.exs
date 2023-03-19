defmodule LaunchCart.Repo.Migrations.CreateWebHooks do
  use Ecto.Migration

  def change do
    create table(:web_hooks) do
      add :description, :string
      add :url, :string
      add :headers, :map
      add :form_id, references(:forms, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:web_hooks, [:form_id])
  end
end
