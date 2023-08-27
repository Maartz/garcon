defmodule Garcon.TestResponder do
  import Garcon.HTTPServer.ResponderHelpers

  @behaviour Garcon.HTTPServer.Responder

  @impl true
  def resp(_req, method, path) do
    cond do
      method == :GET && path == "/hello" ->
        "Hello world"
        |> http_response()
        |> put_headers("Content-Type", "text/html")
        |> put_status(200)

      true ->
        "Not Found"
        |> http_response()
        |> put_headers("Content-Type", "text/html")
        |> put_status(404)
    end
  end
end
