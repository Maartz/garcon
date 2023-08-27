defmodule Garcon.HTTPServer do
  @moduledoc """
  Start a HTTP server on the given port

  This server also logs all requests
  """

  require Logger

  @server_options [
    active: false,
    packet: :http_bin,
    reuseaddr: true
  ]

  def child_spec(init_args) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start, init_args}
    }
  end

  def start(port) do
    ensure_configured!()

    case :gen_tcp.listen(port, @server_options) do
      {:ok, socket} ->
        Logger.info("Started a webserver on port #{port}")

        listen(socket)

      {:error, error} ->
        Logger.error("Cannot start webserver on port #{port}: #{error}")
    end
  end

  def listen(socket) do
    {:ok, req} = :gen_tcp.accept(socket)

    {:ok, {_http_req, method, {_type, path}, _v}} = :gen_tcp.recv(req, 0)

    Logger.info("Received HTTP request #{method} at #{path}")

    respond(req, method, path)

    listen(socket)
  end

  defp respond(req, method, path) do
    %Garcon.HTTPResponse{} = resp = responder().resp(req, method, path)
    response_string = Garcon.HTTPResponse.to_string(resp)

    :gen_tcp.send(req, response_string)

    Logger.info("Response sent: \n#{response_string}")

    :gen_tcp.close(req)
  end

  defp ensure_configured!() do
    case responder() do
      nil ->
        raise "No `responder` configured for `garcon_http_server`"

      _responder ->
        :ok
    end
  end

  defp responder() do
    Application.get_env(:garcon_http_server, :responder)
  end
end
