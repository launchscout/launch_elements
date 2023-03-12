defmodule LaunchCart.ReleaseTasks do

  @app :launch_cart

  alias LaunchCart.Repo
  alias LaunchCart.StripeAccounts.StripeAccount
  alias LaunchCart.Stores.Store
  alias LaunchCart.Carts.{Cart, CartItem}
  alias LaunchCart.Accounts.User

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end

  def wipe_data(i_mean_it: true) do
    [CartItem, Cart, Store, StripeAccount, User] |> Enum.each(fn schema ->
      Repo.delete_all(schema)
    end)
  end

end
