defmodule LaunchCart.CommentSites do
  @moduledoc """
  The CommentSites context.
  """

  import Ecto.Query, warn: false
  alias LaunchCart.Repo

  alias LaunchCart.CommentSites.CommentSite
  alias LaunchCart.Accounts.User

  @doc """
  Returns the list of comment_sites.

  ## Examples

      iex> list_comment_sites()
      [%CommentSite{}, ...]

  """
  def list_comment_sites do
    Repo.all(CommentSite)
  end

  def list_comment_sites(%User{id: user_id}) do
    Repo.all(from comment_site in CommentSite, where: comment_site.user_id == ^user_id)
  end

  @doc """
  Gets a single comment_site.

  Raises `Ecto.NoResultsError` if the Comment site does not exist.

  ## Examples

      iex> get_comment_site!(123)
      %CommentSite{}

      iex> get_comment_site!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment_site!(id), do: Repo.get!(CommentSite, id)

  @doc """
  Creates a comment_site.

  ## Examples

      iex> create_comment_site(%{field: value})
      {:ok, %CommentSite{}}

      iex> create_comment_site(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment_site(attrs \\ %{}) do
    %CommentSite{}
    |> CommentSite.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a comment_site.

  ## Examples

      iex> update_comment_site(comment_site, %{field: new_value})
      {:ok, %CommentSite{}}

      iex> update_comment_site(comment_site, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment_site(%CommentSite{} = comment_site, attrs) do
    comment_site
    |> CommentSite.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a comment_site.

  ## Examples

      iex> delete_comment_site(comment_site)
      {:ok, %CommentSite{}}

      iex> delete_comment_site(comment_site)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment_site(%CommentSite{} = comment_site) do
    Repo.delete(comment_site)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment_site changes.

  ## Examples

      iex> change_comment_site(comment_site)
      %Ecto.Changeset{data: %CommentSite{}}

  """
  def change_comment_site(%CommentSite{} = comment_site, attrs \\ %{}) do
    CommentSite.changeset(comment_site, attrs)
  end
end
