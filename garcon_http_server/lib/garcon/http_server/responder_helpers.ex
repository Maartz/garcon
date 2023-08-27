defmodule Garcon.HTTPServer.ResponderHelpers do
  def http_response(body), do: %Garcon.HTTPResponse{body: body}

  def put_headers(%{headers: headers} = resp, key, value) do
    headers = Map.merge(headers, %{String.downcase(key) => value})
    %{resp | headers: headers}
  end

  def put_status(resp, status), do: %{resp | status: status}
end
