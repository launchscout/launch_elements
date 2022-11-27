defmodule StripeCart.StripeAccountsTest do
  use StripeCart.DataCase

  alias StripeCart.StripeAccounts

  describe "stripe_accounts" do
    alias StripeCart.StripeAccounts.StripeAccount

    import StripeCart.Factory

    @invalid_attrs %{name: nil, stripe_id: nil}

    test "list_stripe_accounts/0 returns all stripe_accounts" do
      stripe_account = insert(:stripe_account)
      assert_equivalent StripeAccounts.list_stripe_accounts(), [stripe_account]
    end

    test "get_stripe_account!/1 returns the stripe_account with given id" do
      stripe_account = insert(:stripe_account)

      assert_equivalent StripeAccounts.get_stripe_account!(stripe_account.id), stripe_account
    end

    test "create_stripe_account/1 with valid data creates a stripe_account" do
      user = insert(:user)
      valid_attrs = %{stripe_user_id: "acc_stripe"}

      assert {:ok, %StripeAccount{} = stripe_account} = StripeAccounts.create_stripe_account(user, valid_attrs)
      assert stripe_account.stripe_id == "acc_stripe"
      # from FakeStripe
      assert stripe_account.name == "Lunch Scout"
    end

    test "create_stripe_account/1 with invalid data returns error changeset" do
      user = insert(:user)
      assert {:error, %Ecto.Changeset{}} = StripeAccounts.create_stripe_account(user, @invalid_attrs)
    end

    test "update_stripe_account/2 with valid data updates the stripe_account" do
      stripe_account = insert(:stripe_account)
      update_attrs = %{name: "some updated name", stripe_id: "some updated stripe_id"}

      assert {:ok, %StripeAccount{} = stripe_account} = StripeAccounts.update_stripe_account(stripe_account, update_attrs)
      assert stripe_account.name == "some updated name"
      assert stripe_account.stripe_id == "some updated stripe_id"
    end

    test "update_stripe_account/2 with invalid data returns error changeset" do
      stripe_account = insert(:stripe_account)
      assert {:error, %Ecto.Changeset{}} = StripeAccounts.update_stripe_account(stripe_account, @invalid_attrs)
      assert_equivalent stripe_account, StripeAccounts.get_stripe_account!(stripe_account.id)
    end

    test "delete_stripe_account/1 deletes the stripe_account" do
      stripe_account = insert(:stripe_account)
      assert {:ok, %StripeAccount{}} = StripeAccounts.delete_stripe_account(stripe_account)
      assert_raise Ecto.NoResultsError, fn -> StripeAccounts.get_stripe_account!(stripe_account.id) end
    end

    test "change_stripe_account/1 returns a stripe_account changeset" do
      stripe_account = insert(:stripe_account)
      assert %Ecto.Changeset{} = StripeAccounts.change_stripe_account(stripe_account)
    end
  end
end
