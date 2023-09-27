defmodule LaunchCart.Comments do
  @moduledoc """
  The Comments context.
  """

  import Ecto.Query, warn: false
  alias LaunchCart.CommentSites
  alias LaunchCart.CommentSites.CommentSite
  alias LaunchCart.Repo

  alias LaunchCart.Comments.{Comment, CommentEmail}

  alias LaunchCart.Mailer

  @doc """
  Returns the list of comments.

  ## Examples

      iex> list_comments()
      [%Comment{}, ...]

  """
  def list_comments(site_id, url) do
    from(c in Comment,
      where: c.comment_site_id == ^site_id and c.url == ^url and c.approved == true,
      order_by: {:desc, c.inserted_at}
    )
    |> Repo.all()
  end

  def list_comments(site_id) do
    from(c in Comment,
      where: c.comment_site_id == ^site_id,
      order_by: {:desc, c.inserted_at}
    )
    |> Repo.all()
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(123)
      %Comment{}

      iex> get_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment!(id), do: Repo.get!(Comment, id)

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs |> maybe_approve_comment())
    |> Repo.insert()
    |> case do
      {:ok, comment} ->
        Phoenix.PubSub.broadcast(
          LaunchCart.PubSub,
          "comments:#{comment.comment_site_id}",
          {:comment_created, comment}
        )

        comment |> CommentEmail.comment_added() |> Mailer.deliver() |> IO.inspect()
        {:ok, comment}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Updates a comment.

  ## Examples

      iex> update_comment(comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, comment} ->
        Phoenix.PubSub.broadcast(
          LaunchCart.PubSub,
          "comments:#{comment.comment_site_id}",
          {:comment_updated, comment}
        )
        {:ok, comment}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Deletes a comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{data: %Comment{}}

  """
  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end

  defp maybe_approve_comment(%{"comment_site_id" => comment_site_id} = attrs),
    do: Map.put(attrs, "approved", approved?(comment_site_id))

  defp maybe_approve_comment(%{comment_site_id: comment_site_id} = attrs),
    do: Map.put(attrs, :approved, approved?(comment_site_id))

  defp maybe_approve_comment(attrs), do: attrs

  defp approved?(comment_site_id) do
    case CommentSites.get_comment_site!(comment_site_id) do
      %CommentSite{requires_approval: false} -> true
      _ -> false
    end
  end
end
