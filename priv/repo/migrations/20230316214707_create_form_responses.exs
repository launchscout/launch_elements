defmodule LaunchCart.Repo.Migrations.CreateFormResponses do
  use Ecto.Migration

  def change do
    create table(:form_responses) do
      add :response, :map
      add :form_id, references(:forms, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:form_responses, [:form_id])
  end
end
