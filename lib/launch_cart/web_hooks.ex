defmodule LaunchCart.WebHooks do
  @moduledoc """
  The WebHooks context.
  """

  import Ecto.Query, warn: false
  alias LaunchCart.Repo

  alias LaunchCart.WebHooks.WebHook
  alias LaunchCart.Forms.Form

  @doc """
  Returns the list of web_hooks.

  ## Examples

      iex> list_web_hooks()
      [%WebHook{}, ...]

  """
  def list_web_hooks do
    Repo.all(WebHook)
  end

  def list_web_hooks(%Form{id: form_id}) do
    Repo.all(from web_hook in WebHook, where: web_hook.form_id == ^form_id)
  end

  @doc """
  Gets a single web_hook.

  Raises `Ecto.NoResultsError` if the Web hook does not exist.

  ## Examples

      iex> get_web_hook!(123)
      %WebHook{}

      iex> get_web_hook!(456)
      ** (Ecto.NoResultsError)

  """
  def get_web_hook!(id), do: Repo.get!(WebHook, id)

  @doc """
  Creates a web_hook.

  ## Examples

      iex> create_web_hook(%{field: value})
      {:ok, %WebHook{}}

      iex> create_web_hook(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_web_hook(attrs \\ %{}) do
    %WebHook{}
    |> WebHook.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a web_hook.

  ## Examples

      iex> update_web_hook(web_hook, %{field: new_value})
      {:ok, %WebHook{}}

      iex> update_web_hook(web_hook, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_web_hook(%WebHook{} = web_hook, attrs) do
    web_hook
    |> WebHook.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a web_hook.

  ## Examples

      iex> delete_web_hook(web_hook)
      {:ok, %WebHook{}}

      iex> delete_web_hook(web_hook)
      {:error, %Ecto.Changeset{}}

  """
  def delete_web_hook(%WebHook{} = web_hook) do
    Repo.delete(web_hook)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking web_hook changes.

  ## Examples

      iex> change_web_hook(web_hook)
      %Ecto.Changeset{data: %WebHook{}}

  """
  def change_web_hook(%WebHook{} = web_hook, attrs \\ %{}) do
    WebHook.changeset(web_hook, attrs)
  end
end
