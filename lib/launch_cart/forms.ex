defmodule LaunchCart.Forms do
  @moduledoc """
  The Forms context.
  """

  import Ecto.Query, warn: false
  alias LaunchCart.Repo

  alias LaunchCart.Forms.Form
  alias LaunchCart.Accounts.User
  alias LaunchCart.WebHooks.WebHook

  @doc """
  Returns the list of forms.

  ## Examples

      iex> list_forms()
      [%Form{}, ...]

  """
  def list_forms do
    Repo.all(Form)
  end

  def list_forms(%User{id: user_id}) do
    Repo.all(from form in Form, where: form.user_id == ^user_id)
  end

  @doc """
  Gets a single form.

  Raises `Ecto.NoResultsError` if the Form does not exist.

  ## Examples

      iex> get_form!(123)
      %Form{}

      iex> get_form!(456)
      ** (Ecto.NoResultsError)

  """
  def get_form!(id), do: Repo.get!(Form, id) |> Repo.preload([:responses, :web_hooks])

  @doc """
  Creates a form.

  ## Examples

      iex> create_form(%{field: value})
      {:ok, %Form{}}

      iex> create_form(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_form(attrs \\ %{}) do
    %Form{}
    |> Form.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a form.

  ## Examples

      iex> update_form(form, %{field: new_value})
      {:ok, %Form{}}

      iex> update_form(form, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_form(%Form{} = form, attrs) do
    form
    |> Form.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a form.

  ## Examples

      iex> delete_form(form)
      {:ok, %Form{}}

      iex> delete_form(form)
      {:error, %Ecto.Changeset{}}

  """
  def delete_form(%Form{} = form) do
    Repo.delete(form)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking form changes.

  ## Examples

      iex> change_form(form)
      %Ecto.Changeset{data: %Form{}}

  """
  def change_form(%Form{} = form, attrs \\ %{}) do
    Form.changeset(form, attrs)
  end

  alias LaunchCart.Forms.FormResponse

  @doc """
  Returns the list of form_responses.

  ## Examples

      iex> list_form_responses()
      [%FormResponse{}, ...]

  """
  def list_form_responses do
    Repo.all(FormResponse)
  end

  @doc """
  Gets a single form_response.

  Raises `Ecto.NoResultsError` if the Form response does not exist.

  ## Examples

      iex> get_form_response!(123)
      %FormResponse{}

      iex> get_form_response!(456)
      ** (Ecto.NoResultsError)

  """
  def get_form_response!(id), do: Repo.get!(FormResponse, id)

  @doc """
  Creates a form_response.

  ## Examples

      iex> create_form_response(%{field: value})
      {:ok, %FormResponse{}}

      iex> create_form_response(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_form_response(attrs \\ %{}) do
    %FormResponse{}
    |> FormResponse.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a form_response.

  ## Examples

      iex> update_form_response(form_response, %{field: new_value})
      {:ok, %FormResponse{}}

      iex> update_form_response(form_response, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_form_response(%FormResponse{} = form_response, attrs) do
    form_response
    |> FormResponse.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a form_response.

  ## Examples

      iex> delete_form_response(form_response)
      {:ok, %FormResponse{}}

      iex> delete_form_response(form_response)
      {:error, %Ecto.Changeset{}}

  """
  def delete_form_response(%FormResponse{} = form_response) do
    Repo.delete(form_response)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking form_response changes.

  ## Examples

      iex> change_form_response(form_response)
      %Ecto.Changeset{data: %FormResponse{}}

  """
  def change_form_response(%FormResponse{} = form_response, attrs \\ %{}) do
    FormResponse.changeset(form_response, attrs)
  end

  def submit_response(%Form{web_hooks: %Ecto.Association.NotLoaded{}} = form, response) do
    Repo.preload(form, :web_hooks) |> submit_response(response)
  end

  def submit_response(%Form{id: form_id, web_hooks: web_hooks}, response) do
    with {:ok, form_response} <- create_form_response(%{form_id: form_id, response: response}) do
      send_web_hooks(web_hooks, response)
      {:ok, form_response}
    end
  end

  defp send_web_hooks(web_hooks, response) do
    web_hooks |> Enum.map(&send_web_hook(&1, response))
  end

  defp send_web_hook(%WebHook{url: url}, response) do
    HTTPoison.post! url, Jason.encode!(response), [{"Content-Type", "application/json"}]
  end
end
