defmodule LaunchCart.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, except: [:__meta__, :comment_site]}

  alias LaunchCart.CommentSites.CommentSite

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "comments" do
    field :author, :string
    field :comment, :string
    field :url, :string
    field :approved, :boolean, default: false
    belongs_to :comment_site, CommentSite

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:author, :comment, :url, :comment_site_id, :approved])
    |> validate_required([:author, :comment, :url, :comment_site_id])
  end
end
