# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :launch_cart, env: config_env()

config :launch_cart,
  ecto_repos: [LaunchCart.Repo]

# Configures the endpoint
config :launch_cart, LaunchCartWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: LaunchCartWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: LaunchCart.PubSub,
  live_view: [signing_salt: "LYciOSHB"]

config :stripity_stripe, api_key: System.get_env("STRIPE_API_KEY")

config :launch_cart, stripe_client_id: System.get_env("STRIPE_CLIENT_ID")

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :launch_cart, LaunchCart.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
# config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2020 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ],
  package: [
    args:
      ~w(js/index.js --bundle --target=es2020 --outdir=../assets/dist --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :dart_sass,
  version: "1.54.5",
  default: [
    args: ~w(css/app.scss ../priv/static/assets/app.css),
    cd: Path.expand("../assets", __DIR__)
  ]

config :waffle,
  storage: Waffle.Storage.Local,
  # Edit this path to match your storage directory
  storage_dir_prefix: "priv/static",
  storage_dir: "uploads"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
