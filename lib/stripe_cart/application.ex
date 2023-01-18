defmodule LaunchCart.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  import Cachex.Spec

  @impl true
  def start(_type, _args) do
    children =
      [
        # Start the Ecto repository
        LaunchCart.Repo,
        # Start the Telemetry supervisor
        LaunchCartWeb.Telemetry,
        # Start the PubSub system
        {Phoenix.PubSub, name: LaunchCart.PubSub},
        # Start the Endpoint (http/https)
        LaunchCartWeb.Endpoint
        # Start a worker by calling: LaunchCart.Worker.start_link(arg)
        # {LaunchCart.Worker, arg}
      ] ++
        Application.get_env(:stripe_cart, :supervised_processes, [
          {Cachex,
           name: :stripe_products,
           warmers: [warmer(module: LaunchCart.LaunchCacheWarmer, state: %{})]}
        ])

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LaunchCart.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LaunchCartWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
