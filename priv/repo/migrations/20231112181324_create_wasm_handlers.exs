defmodule LaunchCart.Repo.Migrations.CreateWasmHandlers do
  use Ecto.Migration

  def change do
    create table(:wasm_handlers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :wasm, :string
      add :form_id, references(:forms, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:wasm_handlers, [:form_id])
  end
end
