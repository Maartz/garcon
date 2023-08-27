defmodule GarconHttpServerTest do
  use ExUnit.Case, async: false

  setup_all do
    Finch.start_link(name: Garcon.Finch)
    :ok
  end

  describe "start/2" do
    setup tags do
      responder = tags[:responder]

      old_responder =
        Application.get_env(:garcon_http_server, :responder)

      Application.put_env(:garcon_http_server, :responder, responder)

      on_exit(fn ->
        Application.put_env(:garcon_http_server, :responder, old_responder)
      end)
    end

    @tag responder: nil

    test "raises when responder not configured" do
      assert_raise(RuntimeError, "No `responder` configured for `garcon_http_server`", fn ->
        Garcon.HTTPServer.start(4000)
      end)
    end

    @tag responder: Garcon.TestResponder

    test "starts a server when responder is configured" do
      Task.start_link(fn -> Garcon.HTTPServer.start(4000) end)

      {:ok, response} =
        :get
        |> Finch.build("http://localhost:4000/hello")
        |> Finch.request(Garcon.Finch)

      assert response.body == "Hello world"
      assert response.status == 200
      assert {"content-type", "text/html"} in response.headers

      {:ok, response} =
        :get
        |> Finch.build("http://localhost:4000/bad")
        |> Finch.request(Garcon.Finch)

      assert response.body == "Not Found"
      assert response.status == 404
      assert {"content-type", "text/html"} in response.headers
    end
  end
end
