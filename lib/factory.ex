defmodule StripeCart.Factory do

  alias Faker.Internet

  use ExMachina.Ecto, repo: StripeCart.Repo

  alias StripeCart.Stores.Store
  alias StripeCart.Accounts.User

  def store_factory() do
    %Store{
      name: "Bad Burgers",
      user: build(:user)
    }
  end

  def user_factory() do
    %User{
      email: Internet.email(),
      hashed_password: Bcrypt.hash_pwd_salt("password")
    }
  end
end
