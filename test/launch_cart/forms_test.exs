defmodule LaunchCart.FormsTest do
  use LaunchCart.DataCase

  alias LaunchCart.Forms.{Form, FormResponse}
  alias LaunchCart.Forms
  import LaunchCart.Factory

  import Swoosh.TestAssertions

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

  describe "submit_response" do
    test "creates response and sends web hook" do
      bypass = Bypass.open()
      form = insert(:form)
      web_hook = insert(:web_hook, form: form, url: "http://localhost:#{bypass.port}/hook")

      Bypass.expect_once(bypass, "POST", "/hook", fn conn ->
        {:ok, body, _conn} = Plug.Conn.read_body(conn)
        assert body =~ "foo"
        Plug.Conn.resp(conn, 200, "")
      end)

      assert {:ok, %FormResponse{response: %{foo: "bar"}}} =
               Forms.submit_response(form, %{foo: "bar"})
    end

    test "sends emails" do
      form = insert(:form)
      form_email = insert(:form_email, form: form, email: "foo@bar.com", subject: "Nice to meet ya")

      assert {:ok, %FormResponse{response: %{foo: "bar"}}} =
        Forms.submit_response(form, %{foo: "bar"})

      assert_email_sent(subject: "Nice to meet ya", to: [{"foo@bar.com", "foo@bar.com"}])
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

      assert {:ok, %FormResponse{} = form_response} =
               Forms.update_form_response(form_response, update_attrs)

      assert form_response.response == %{}
    end

    test "update_form_response/2 with invalid data returns error changeset" do
      form_response = insert(:form_response)

      assert {:error, %Ecto.Changeset{}} =
               Forms.update_form_response(form_response, @invalid_attrs)
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

  describe "form_emails" do
    alias LaunchCart.Forms.FormEmail

    import LaunchCart.FormsFixtures

    @invalid_attrs %{content: nil, email: nil, subject: nil}

    test "list_form_emails/0 returns all form_emails" do
      form_email = form_email_fixture()
      assert Forms.list_form_emails() == [form_email]
    end

    test "get_form_email!/1 returns the form_email with given id" do
      form_email = form_email_fixture()
      assert Forms.get_form_email!(form_email.id) == form_email
    end

    test "create_form_email/1 with valid data creates a form_email" do
      valid_attrs = %{content: "some content", email: "some email", subject: "some subject"}

      assert {:ok, %FormEmail{} = form_email} = Forms.create_form_email(valid_attrs)
      assert form_email.content == "some content"
      assert form_email.email == "some email"
      assert form_email.subject == "some subject"
    end

    test "create_form_email/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Forms.create_form_email(@invalid_attrs)
    end

    test "update_form_email/2 with valid data updates the form_email" do
      form_email = form_email_fixture()
      update_attrs = %{content: "some updated content", email: "some updated email", subject: "some updated subject"}

      assert {:ok, %FormEmail{} = form_email} = Forms.update_form_email(form_email, update_attrs)
      assert form_email.content == "some updated content"
      assert form_email.email == "some updated email"
      assert form_email.subject == "some updated subject"
    end

    test "update_form_email/2 with invalid data returns error changeset" do
      form_email = form_email_fixture()
      assert {:error, %Ecto.Changeset{}} = Forms.update_form_email(form_email, @invalid_attrs)
      assert form_email == Forms.get_form_email!(form_email.id)
    end

    test "delete_form_email/1 deletes the form_email" do
      form_email = form_email_fixture()
      assert {:ok, %FormEmail{}} = Forms.delete_form_email(form_email)
      assert_raise Ecto.NoResultsError, fn -> Forms.get_form_email!(form_email.id) end
    end

    test "change_form_email/1 returns a form_email changeset" do
      form_email = form_email_fixture()
      assert %Ecto.Changeset{} = Forms.change_form_email(form_email)
    end
  end

  describe "wasm_handlers" do
    alias LaunchCart.Forms.WasmHandler

    import LaunchCart.FormsFixtures

    @invalid_attrs %{wasm: nil}

    test "list_wasm_handlers/0 returns all wasm_handlers" do
      wasm_handler = wasm_handler_fixture()
      assert Forms.list_wasm_handlers() == [wasm_handler]
    end

    test "get_wasm_handler!/1 returns the wasm_handler with given id" do
      wasm_handler = wasm_handler_fixture()
      assert Forms.get_wasm_handler!(wasm_handler.id) == wasm_handler
    end

    test "create_wasm_handler/1 with valid data creates a wasm_handler" do
      valid_attrs = %{wasm: "some wasm"}

      assert {:ok, %WasmHandler{} = wasm_handler} = Forms.create_wasm_handler(valid_attrs)
      assert wasm_handler.wasm == "some wasm"
    end

    test "create_wasm_handler/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Forms.create_wasm_handler(@invalid_attrs)
    end

    test "update_wasm_handler/2 with valid data updates the wasm_handler" do
      wasm_handler = wasm_handler_fixture()
      update_attrs = %{wasm: "some updated wasm"}

      assert {:ok, %WasmHandler{} = wasm_handler} = Forms.update_wasm_handler(wasm_handler, update_attrs)
      assert wasm_handler.wasm == "some updated wasm"
    end

    test "update_wasm_handler/2 with invalid data returns error changeset" do
      wasm_handler = wasm_handler_fixture()
      assert {:error, %Ecto.Changeset{}} = Forms.update_wasm_handler(wasm_handler, @invalid_attrs)
      assert wasm_handler == Forms.get_wasm_handler!(wasm_handler.id)
    end

    test "delete_wasm_handler/1 deletes the wasm_handler" do
      wasm_handler = wasm_handler_fixture()
      assert {:ok, %WasmHandler{}} = Forms.delete_wasm_handler(wasm_handler)
      assert_raise Ecto.NoResultsError, fn -> Forms.get_wasm_handler!(wasm_handler.id) end
    end

    test "change_wasm_handler/1 returns a wasm_handler changeset" do
      wasm_handler = wasm_handler_fixture()
      assert %Ecto.Changeset{} = Forms.change_wasm_handler(wasm_handler)
    end
  end
end
