defmodule LaunchCartWeb.UserRegistrationController do
  use LaunchCartWeb, :controller

  alias LaunchCart.Accounts
  alias LaunchCart.Accounts.User

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, user} <- Accounts.register_user(user_params),
         {:ok, _} <-
           Accounts.deliver_user_confirmation_instructions(
             user,
             &Routes.user_confirmation_url(conn, :edit, &1)
           ) do
      render(conn, "thanks.html", user: user)
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
