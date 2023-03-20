defmodule LaunchCart.Repo.Migrations.CreateFormEmails do
  use Ecto.Migration

  def change do
    create table(:form_emails) do
      add :email, :string
      add :subject, :string
      add :content, :text
      add :form_id, references(:forms, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:form_emails, [:form_id])
  end
end
