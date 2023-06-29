import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :launch_cart, LaunchCart.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "launch_cart_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :launch_cart, LaunchCartWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "1/0iThVdx3Q0ZDwJxvxh67k2vvhh2BJr+N+JM6e6bfJbEqaO+2WQDBrJgqfvcvZo",
  server: true

# In test we don't send emails.
config :launch_cart, LaunchCart.Mailer, adapter: Swoosh.Adapters.Test

config :launch_cart,
  create_checkout_session: &LaunchCart.Test.FakeLaunch.create_checkout_session/2,
  stripe_oauth: LaunchCart.Test.FakeLaunch,
  get_stripe_account: &LaunchCart.Test.FakeLaunch.get_stripe_account/1,
  list_stripe_products: &LaunchCart.Test.FakeLaunch.list_products/2,
  list_stripe_prices: &LaunchCart.Test.FakeLaunch.list_prices/2,
  get_checkout_session: &LaunchCart.Test.FakeLaunch.get_session/2,
  get_stripe_price: &LaunchCart.Test.FakeLaunch.get_price/2,
  supervised_processes: [{Cachex, name: :stripe_products}]

# Print only warnings and errors during test
config :logger, level: :info

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :launch_cart, :sandbox, Ecto.Adapters.SQL.Sandbox

config :wallaby,
  otp_app: :launch_cart,
  base_url: "http://localhost:4002",
  chromedriver: [
    headless: false
  ]
