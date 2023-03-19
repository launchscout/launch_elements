defmodule LaunchCart.WebHooksTest do
  use LaunchCart.DataCase

  import LaunchCart.Factory

  alias LaunchCart.WebHooks

  describe "web_hooks" do
    alias LaunchCart.WebHooks.WebHook

    import LaunchCart.WebHooksFixtures

    @invalid_attrs %{description: nil, headers: nil, url: nil}

    test "list_web_hooks/0 returns all web_hooks" do
      web_hook = insert(:web_hook)
      assert WebHooks.list_web_hooks() |> Enum.map(& &1.id) == [web_hook.id]
    end

    test "get_web_hook!/1 returns the web_hook with given id" do
      web_hook = insert(:web_hook)
      assert WebHooks.get_web_hook!(web_hook.id)
    end

    test "create_web_hook/1 with valid data creates a web_hook" do
      form = insert(:form)
      valid_attrs = %{description: "some description", headers: %{}, form_id: form.id, url: "some url"}

      assert {:ok, %WebHook{} = web_hook} = WebHooks.create_web_hook(valid_attrs)
      assert web_hook.description == "some description"
      assert web_hook.headers == %{}
      assert web_hook.url == "some url"
    end

    test "create_web_hook/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = WebHooks.create_web_hook(@invalid_attrs)
    end

    test "update_web_hook/2 with valid data updates the web_hook" do
      web_hook = insert(:web_hook)
      update_attrs = %{description: "some updated description", headers: %{}, url: "some updated url"}

      assert {:ok, %WebHook{} = web_hook} = WebHooks.update_web_hook(web_hook, update_attrs)
      assert web_hook.description == "some updated description"
      assert web_hook.headers == %{}
      assert web_hook.url == "some updated url"
    end

    test "update_web_hook/2 with invalid data returns error changeset" do
      web_hook = insert(:web_hook)
      assert {:error, %Ecto.Changeset{}} = WebHooks.update_web_hook(web_hook, @invalid_attrs)
    end

    test "delete_web_hook/1 deletes the web_hook" do
      web_hook = insert(:web_hook)
      assert {:ok, %WebHook{}} = WebHooks.delete_web_hook(web_hook)
      assert_raise Ecto.NoResultsError, fn -> WebHooks.get_web_hook!(web_hook.id) end
    end

    test "change_web_hook/1 returns a web_hook changeset" do
      web_hook = insert(:web_hook)
      assert %Ecto.Changeset{} = WebHooks.change_web_hook(web_hook)
    end
  end
end
