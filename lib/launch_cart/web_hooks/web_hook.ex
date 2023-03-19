defmodule LaunchCart.WebHooks.WebHook do
  use Ecto.Schema
  import Ecto.Changeset

  alias LaunchCart.Forms.Form

  @foreign_key_type :binary_id
  schema "web_hooks" do
    field :description, :string
    field :headers, :map
    field :url, :string
    belongs_to :form, Form

    timestamps()
  end

  @doc false
  def changeset(web_hook, attrs) do
    web_hook
    |> cast(attrs, [:description, :url, :headers, :form_id])
    |> validate_required([:description, :url, :form_id])
  end
end
