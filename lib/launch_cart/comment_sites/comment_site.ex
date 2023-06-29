defmodule LaunchCart.CommentSites.CommentSite do
  use Ecto.Schema
  import Ecto.Changeset
  alias LaunchCart.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "comment_sites" do
    field :name, :string
    field :url, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(comment_site, attrs) do
    comment_site
    |> cast(attrs, [:name, :url])
    |> validate_required([:name, :url])
  end
end
