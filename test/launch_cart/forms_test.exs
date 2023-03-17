defmodule LaunchCart.FormsTest do
  use LaunchCart.DataCase

  alias LaunchCart.Forms

  describe "forms" do
    alias LaunchCart.Forms.Form

    import LaunchCart.FormsFixtures

    @invalid_attrs %{name: nil}

    test "list_forms/0 returns all forms" do
      form = form_fixture()
      assert Forms.list_forms() == [form]
    end

    test "get_form!/1 returns the form with given id" do
      form = form_fixture()
      assert Forms.get_form!(form.id) == form
    end

    test "create_form/1 with valid data creates a form" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Form{} = form} = Forms.create_form(valid_attrs)
      assert form.name == "some name"
    end

    test "create_form/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Forms.create_form(@invalid_attrs)
    end

    test "update_form/2 with valid data updates the form" do
      form = form_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Form{} = form} = Forms.update_form(form, update_attrs)
      assert form.name == "some updated name"
    end

    test "update_form/2 with invalid data returns error changeset" do
      form = form_fixture()
      assert {:error, %Ecto.Changeset{}} = Forms.update_form(form, @invalid_attrs)
      assert form == Forms.get_form!(form.id)
    end

    test "delete_form/1 deletes the form" do
      form = form_fixture()
      assert {:ok, %Form{}} = Forms.delete_form(form)
      assert_raise Ecto.NoResultsError, fn -> Forms.get_form!(form.id) end
    end

    test "change_form/1 returns a form changeset" do
      form = form_fixture()
      assert %Ecto.Changeset{} = Forms.change_form(form)
    end
  end

  describe "form_responses" do
    alias LaunchCart.Forms.FormResponse

    import LaunchCart.FormsFixtures

    @invalid_attrs %{response: nil}

    test "list_form_responses/0 returns all form_responses" do
      form_response = form_response_fixture()
      assert Forms.list_form_responses() == [form_response]
    end

    test "get_form_response!/1 returns the form_response with given id" do
      form_response = form_response_fixture()
      assert Forms.get_form_response!(form_response.id) == form_response
    end

    test "create_form_response/1 with valid data creates a form_response" do
      valid_attrs = %{response: %{}}

      assert {:ok, %FormResponse{} = form_response} = Forms.create_form_response(valid_attrs)
      assert form_response.response == %{}
    end

    test "create_form_response/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Forms.create_form_response(@invalid_attrs)
    end

    test "update_form_response/2 with valid data updates the form_response" do
      form_response = form_response_fixture()
      update_attrs = %{response: %{}}

      assert {:ok, %FormResponse{} = form_response} = Forms.update_form_response(form_response, update_attrs)
      assert form_response.response == %{}
    end

    test "update_form_response/2 with invalid data returns error changeset" do
      form_response = form_response_fixture()
      assert {:error, %Ecto.Changeset{}} = Forms.update_form_response(form_response, @invalid_attrs)
      assert form_response == Forms.get_form_response!(form_response.id)
    end

    test "delete_form_response/1 deletes the form_response" do
      form_response = form_response_fixture()
      assert {:ok, %FormResponse{}} = Forms.delete_form_response(form_response)
      assert_raise Ecto.NoResultsError, fn -> Forms.get_form_response!(form_response.id) end
    end

    test "change_form_response/1 returns a form_response changeset" do
      form_response = form_response_fixture()
      assert %Ecto.Changeset{} = Forms.change_form_response(form_response)
    end
  end
end
