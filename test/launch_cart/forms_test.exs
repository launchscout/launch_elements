defmodule LaunchCart.FormsTest do
  use LaunchCart.DataCase

  alias LaunchCart.Forms
  import LaunchCart.Factory

  describe "forms" do
    alias LaunchCart.Forms.Form

    import LaunchCart.FormsFixtures

    @invalid_attrs %{name: nil}

    test "list_forms/0 returns all forms" do
      form = insert(:form)
      assert Forms.list_forms() |> Enum.map(& &1.id) == [form.id]
    end

    test "list_forms/1 returns all forms for specific user" do
      user = insert(:user)
      form = insert(:form, user: user)
      other_form = insert(:form)
      assert Forms.list_forms(user) |> Enum.map(& &1.id) == [form.id]
    end

    test "get_form!/1 returns the form with given id" do
      form = insert(:form)
      assert Forms.get_form!(form.id)
    end

    test "create_form/1 with valid data creates a form" do
      user = insert(:user)
      valid_attrs = %{name: "some name", user_id: user.id}

      assert {:ok, %Form{} = form} = Forms.create_form(valid_attrs)
      assert form.name == "some name"
    end

    test "create_form/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Forms.create_form(@invalid_attrs)
    end

    test "update_form/2 with valid data updates the form" do
      form = insert(:form)
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Form{} = form} = Forms.update_form(form, update_attrs)
      assert form.name == "some updated name"
    end

    test "update_form/2 with invalid data returns error changeset" do
      form = insert(:form)
      assert {:error, %Ecto.Changeset{}} = Forms.update_form(form, @invalid_attrs)
    end

    test "delete_form/1 deletes the form" do
      form = insert(:form)
      assert {:ok, %Form{}} = Forms.delete_form(form)
      assert_raise Ecto.NoResultsError, fn -> Forms.get_form!(form.id) end
    end

    test "change_form/1 returns a form changeset" do
      form = insert(:form)
      assert %Ecto.Changeset{} = Forms.change_form(form)
    end
  end

  describe "form_responses" do
    alias LaunchCart.Forms.FormResponse

    import LaunchCart.FormsFixtures

    @invalid_attrs %{response: nil}

    test "list_form_responses/0 returns all form_responses" do
      form_response = insert(:form_response)
      assert Forms.list_form_responses() |> Enum.map(& &1.id) == [form_response.id]
    end

    test "get_form_response!/1 returns the form_response with given id" do
      form_response = insert(:form_response)
      assert Forms.get_form_response!(form_response.id)
    end

    test "create_form_response/1 with valid data creates a form_response" do
      form = insert(:form)
      valid_attrs = %{response: %{"foo" => "bar"}, form_id: form.id}

      assert {:ok, %FormResponse{} = form_response} = Forms.create_form_response(valid_attrs)
      assert form_response.response == %{"foo" => "bar"}
    end

    test "create_form_response/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Forms.create_form_response(@invalid_attrs)
    end

    test "update_form_response/2 with valid data updates the form_response" do
      form_response = insert(:form_response)
      update_attrs = %{response: %{}}

      assert {:ok, %FormResponse{} = form_response} = Forms.update_form_response(form_response, update_attrs)
      assert form_response.response == %{}
    end

    test "update_form_response/2 with invalid data returns error changeset" do
      form_response = insert(:form_response)
      assert {:error, %Ecto.Changeset{}} = Forms.update_form_response(form_response, @invalid_attrs)
    end

    test "delete_form_response/1 deletes the form_response" do
      form_response = insert(:form_response)
      assert {:ok, %FormResponse{}} = Forms.delete_form_response(form_response)
      assert_raise Ecto.NoResultsError, fn -> Forms.get_form_response!(form_response.id) end
    end

    test "change_form_response/1 returns a form_response changeset" do
      form_response = insert(:form_response)
      assert %Ecto.Changeset{} = Forms.change_form_response(form_response)
    end
  end
end
