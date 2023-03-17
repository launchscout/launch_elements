defmodule LaunchCart.Factory do

  alias Faker.Internet

  use ExMachina.Ecto, repo: LaunchCart.Repo

  alias LaunchCart.Stores.Store
  alias LaunchCart.Accounts.User
  alias LaunchCart.Carts.Cart
  alias LaunchCart.Carts.CartItem
  alias LaunchCart.StripeAccounts.StripeAccount
  alias LaunchCart.Forms.Form

  def store_factory() do
    %Store{
      name: "Bad Burgers",
      user: build(:user),
      stripe_account: build(:stripe_account)
    }
  end

  def user_factory() do
    %User{
      email: Internet.email(),
      hashed_password: Bcrypt.hash_pwd_salt("password"),
      active?: true
    }
  end

  def stripe_account_factory() do
    %StripeAccount{
      name: "My account",
      stripe_id: "acct_foo",
      user: build(:user)
    }
  end

  def cart_factory() do
    %Cart{
      store: build(:store),
      items: [build(:cart_item)]
    }
  end

  def cart_item_factory() do
    %CartItem{
      price: 1100,
      quantity: 1,
      stripe_price_id: "price_123",
      product: %{name: "Thing", description: "blah"}
    }
  end

  def form_factory() do
    %Form{
      name: "Formy McFormFace",
      user: build(:user)
    }
  end
end
