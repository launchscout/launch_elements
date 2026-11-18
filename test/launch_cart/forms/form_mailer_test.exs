defmodule LaunchCart.Forms.FormMailerTest do
  use ExUnit.Case, async: true

  import Swoosh.TestAssertions

  alias LaunchCart.Forms.{FormEmail, FormMailer}

  setup do
    %{notification: %FormEmail{email: "owner@example.com", subject: "Contact form"}}
  end

  test "sets Reply-To to the visitor while preserving the sender and recipient", %{
    notification: notification
  } do
    assert {:ok, _} =
             FormMailer.send_response_email(notification, %{
               "email" => "visitor@example.com",
               "message" => "Hello!"
             })

    assert_email_sent(
      from: {"Launch Form", "launchform@launchscout.com"},
      to: [{"owner@example.com", "owner@example.com"}],
      subject: "Contact form",
      reply_to: {"", "visitor@example.com"}
    )
  end

  test "trims whitespace around the visitor's address", %{notification: notification} do
    assert {:ok, _} =
             FormMailer.send_response_email(notification, %{"email" => " visitor@example.com "})

    assert_email_sent(reply_to: {"", "visitor@example.com"})
  end

  test "sends notifications without an email field", %{notification: notification} do
    assert {:ok, _} = FormMailer.send_response_email(notification, %{"message" => "Hello!"})
    assert_email_sent(fn email -> assert is_nil(email.reply_to) end)
  end

  for address <- [
        nil,
        "",
        "   ",
        "not-an-email",
        "visitor @example.com",
        123,
        "visitor@example.com,other@example.com",
        "visitor@example.com\r\nBcc: other@example.com"
      ] do
    test "omits Reply-To for #{inspect(address)}", %{notification: notification} do
      assert {:ok, _} =
               FormMailer.send_response_email(notification, %{"email" => unquote(address)})

      assert_email_sent(fn email -> assert is_nil(email.reply_to) end)
    end
  end
end
