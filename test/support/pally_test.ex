defmodule LaunchCartWeb.PallyTest do
  import Phoenix.ConnTest, only: [html_response: 2]
  alias Plug.Conn
  alias Wallaby.Session

  defmacro __using__(_opts) do
    quote do
      require LaunchCartWeb.PallyTest
    end
  end

  defmacro here(conn_or_session) do
    quote do
      LaunchCartWeb.PallyTest.here(unquote(conn_or_session), __ENV__, __MODULE__)
    end
  end

  def here(conn_or_session, env, module) do
    filename = get_filename(env, module)

    get_html(conn_or_session)
    |> write_html(filename)
  end

  defp get_html(%Conn{} = conn) do
    html_response(conn, 200)
    |> Floki.parse_document!()
    |> Floki.raw_html()
  end

  defp get_html(%Session{} = session) do
    Wallaby.Browser.page_source(session)
  end

  defp write_html(html, filename) do
    Path.join([File.cwd!(), "/test/axe_html", filename])
    |> File.write(html, [:write])
    |> IO.inspect()
  end

  defp get_filename(env, module) do
    "#{module |> get_module_name()}_#{env.line}.html"
    |> String.replace(" ", "_")
  end

  defp get_module_name(module) do
    module |> Atom.to_string() |> String.downcase() |> String.splitter(".") |> Enum.take(-1)
  end
end
