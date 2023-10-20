defmodule LaunchCart.Factory do

  alias Faker.Person
  alias Faker.Lorem
  alias Faker.Internet

  use ExMachina.Ecto, repo: LaunchCart.Repo

  alias LaunchCart.Stores.Store
  alias LaunchCart.Accounts.User
  alias LaunchCart.Carts.Cart
  alias LaunchCart.Carts.CartItem
  alias LaunchCart.StripeAccounts.StripeAccount
  alias LaunchCart.CommentSites.CommentSite
  alias LaunchCart.Comments.Comment
  alias LaunchCart.Forms.{Form, FormResponse, FormEmail}
  alias LaunchCart.WebHooks.WebHook

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
      confirmed_at: DateTime.utc_now()
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

  def form_response_factory() do
    %FormResponse{
      form: build(:form),
      response: %{name: "Bob", thoughts: "I think therefore I am"}
    }
  end

  def web_hook_factory() do
    %WebHook{
      form: build(:form),
      url: "https://launchscout.com",
      description: "Tell Launch Scout whats up",
      headers: %{}
    }
  end

  def form_email_factory() do
    %FormEmail{
      form: build(:form),
      email: Internet.email(),
      subject: Lorem.words(2..4)
    }
  end

  def comment_site_factory() do
    %CommentSite{
      user: build(:user),
      name: "My Comment Site",
      url: "https://launchscout.com"
    }
  end

  def comment_factory() do
    %Comment{
      comment_site: build(:comment_site),
      author: Person.name,
      url: Internet.url(),
      approved: true,
      comment: "I think therefore I am"
    }
  end
end
