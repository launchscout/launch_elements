defmodule LaunchCartWeb.Router do
  use LaunchCartWeb, :router

  import LaunchCartWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {LaunchCartWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LaunchCartWeb do
    pipe_through :browser

    get "/fake_stores/:store_id", PageController, :fake_store
    get "/fake_form/:form_id", PageController, :fake_form
    get "/fake_form_recaptcha/:form_id", PageController, :fake_form_recaptcha
    get "/", PageController, :index
    get "/api_docs", PageController, :api_docs
    get "/usage_docs", PageController, :usage_docs
  end

  # Other scopes may use custom stacks.
  # scope "/api", LaunchCartWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: LaunchCartWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", LaunchCartWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]


    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", LaunchCartWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/stripe_accounts/authorize_stripe", StripeAccountController, :authorize_stripe
    get "/stripe_accounts/connect_account", StripeAccountController, :connect_account
    get "/stripe_accounts/:id", StripeAccountController, :show
    get "/stripe_accounts", StripeAccountController, :index
    delete "/stripe_accounts/:id", StripeAccountController, :delete

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  live_session :authenticated, on_mount: LaunchCartWeb.AssignCurrentUser do
    scope "/", LaunchCartWeb do
      pipe_through [:browser, :require_authenticated_user]
      live "/stores", StoreLive.Index, :index
      live "/stores/new", StoreLive.Index, :new
      live "/stores/:id/edit", StoreLive.Index, :edit

      live "/stores/:id", StoreLive.Show, :show
      live "/stores/:id/show/edit", StoreLive.Show, :edit

      live "/forms", FormLive.Index, :index
      live "/forms/new", FormLive.Index, :new
      live "/forms/:id/edit", FormLive.Index, :edit

      live "/forms/:id", FormLive.Show, :show
      live "/forms/:id/show/edit", FormLive.Show, :edit

      live "/forms/:id/form_responses", FormLive.FormResponses, :index

      live "/web_hooks", WebHookLive.Index, :index
      live "/web_hooks/new", WebHookLive.Index, :new
      live "/web_hooks/:id/edit", WebHookLive.Index, :edit

      live "/web_hooks/:id", WebHookLive.Show, :show
      live "/web_hooks/:id/show/edit", WebHookLive.Show, :edit

      live "/comment_sites", CommentSiteLive.Index, :index
      live "/comment_sites/new", CommentSiteLive.Index, :new
      live "/comment_sites/:id/edit", CommentSiteLive.Index, :edit

      live "/comment_sites/:id", CommentSiteLive.Show, :show
      live "/comment_sites/:id/show/edit", CommentSiteLive.Show, :edit
    end
  end

  scope "/", LaunchCartWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end
end
