defmodule LaunchCartWeb.UserRegistrationController do
  use LaunchCartWeb, :controller

  alias LaunchCart.Accounts
  alias LaunchCart.Accounts.User
  alias LaunchCartWeb.UserAuth

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} -> render(conn, "thanks.html", user: user)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
