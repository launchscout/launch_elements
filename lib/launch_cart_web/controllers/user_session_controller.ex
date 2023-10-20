defmodule LaunchCartWeb.UserSessionController do
  use LaunchCartWeb, :controller

  alias LaunchCart.Accounts
  alias LaunchCart.Accounts.User
  alias LaunchCartWeb.UserAuth

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    case Accounts.get_user_by_email_and_password(email, password) do
      %User{confirmed_at: nil} ->
        render(conn, "new.html",
          error_message: "Please check your email for confirmation instructions."
        )

      %User{} = user ->
        UserAuth.log_in_user(conn, user, user_params)

      nil ->
        # In order to prevent user enumeration attacks, don't disclose whether the email is registered
        render(conn, "new.html", error_message: "Invalid email or password")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
