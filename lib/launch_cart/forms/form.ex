defmodule LaunchCart.Forms.Form do
  use Ecto.Schema
  import Ecto.Changeset

  alias LaunchCart.Accounts.User
  alias LaunchCart.Forms.{FormResponse, FormEmail, WasmHandler}
  alias LaunchCart.WebHooks.WebHook

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "forms" do
    field :name, :string
    belongs_to :user, User
    has_many :responses, FormResponse
    has_many :web_hooks, WebHook
    has_many :form_emails, FormEmail
    has_many :wasm_handlers, WasmHandler

    timestamps()
  end

  @doc false
  def changeset(form, attrs) do
    form
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name, :user_id])
  end
end
