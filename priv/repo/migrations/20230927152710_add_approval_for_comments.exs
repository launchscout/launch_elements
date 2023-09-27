defmodule LaunchCart.Repo.Migrations.AddApprovalForComments do
  use Ecto.Migration

  def change do
    alter table(:comment_sites) do
      add :requires_approval, :boolean, default: false
    end

    alter table(:comments) do
      add :approved, :boolean
    end
  end
end
