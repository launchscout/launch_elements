defmodule LaunchCart.Forms.FormMailer do
  import Swoosh.Email

  alias LaunchCart.Mailer
  alias LaunchCart.Forms.FormEmail

  def send_response_email(%FormEmail{email: email, subject: subject}, response) do
    new()
    |> to({email, email})
    |> from({"Launch Form", "launchform@launchscout.com"})
    |> put_reply_to(response["email"])
    |> subject(subject)
    |> text_body("""
    Your form has received a submission.
    #{response |> Enum.map(fn {key, value} -> "#{key}: #{value}\n" end)}
    """)
    |> Mailer.deliver()
  end

  defp put_reply_to(email, address) when is_binary(address) do
    address = String.trim(address)

    if Regex.match?(~r/\A[^\s@,;<>]+@[^\s@,;<>]+\z/u, address) do
      reply_to(email, address)
    else
      email
    end
  end

  defp put_reply_to(email, _address), do: email
end
