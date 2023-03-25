defmodule LaunchCart.Forms.FormMailer do
  import Swoosh.Email

  alias LaunchCart.Mailer
  alias LaunchCart.Forms.FormEmail

  def send_response_email(%FormEmail{email: email, subject: subject}, response) do
    new()
    |> to({email, email})
    |> from({"Launch Form", "launchform@launchscout.com"})
    |> subject(subject)
    |> text_body("""
    Your form has received a submission.
    #{response |> Enum.map(fn {key, value} -> "#{key}: #{value}\n" end)}
    """)
    |> Mailer.deliver()
  end
end
