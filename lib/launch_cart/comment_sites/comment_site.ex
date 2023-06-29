defmodule LaunchCart.CommentSites.CommentSite do
  use Ecto.Schema
  import Ecto.Changeset
  alias LaunchCart.Accounts.User
  alias LaunchCart.Comments.Comment

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "comment_sites" do
    field :name, :string
    field :url, :string
    belongs_to :user, User
    has_many :comments, Comment

    timestamps()
  end

  @doc false
  def changeset(comment_site, attrs) do
    comment_site
    |> cast(attrs, [:name, :url, :user_id])
    |> validate_required([:name, :url])
  end
end
