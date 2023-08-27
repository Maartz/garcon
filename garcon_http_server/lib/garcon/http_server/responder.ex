defmodule Garcon.HTTPServer.Responder do
  @type method :: :GET | :POST | :PUT | :PATCH | :DELETE

  @callback resp(term(), method(), String.t()) :: Garcon.HTTPResponse.t()
end
