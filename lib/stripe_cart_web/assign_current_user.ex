defmodule StripeCartWeb.AssignCurrentUser do

  alias StripeCart.Accounts
  import Phoenix.LiveView

  def on_mount(:default, _params, %{"user_token" => user_token}, socket) do
    {:cont, assign(socket, :current_user, Accounts.get_user_by_session_token(user_token))}
  end

end
