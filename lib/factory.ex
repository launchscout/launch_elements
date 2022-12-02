defmodule StripeCart.Factory do

  alias Faker.Internet

  use ExMachina.Ecto, repo: StripeCart.Repo

  alias StripeCart.Stores.Store
  alias StripeCart.Accounts.User
  alias StripeCart.Carts.Cart
  alias StripeCart.Carts.CartItem
  alias StripeCart.StripeAccounts.StripeAccount

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
      hashed_password: Bcrypt.hash_pwd_salt("password")
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

end
