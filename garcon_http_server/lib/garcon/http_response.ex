defmodule Garcon.HTTPResponse do
  defstruct headers: %{}, body: "", status: 200

  @type t :: %__MODULE__{
          headers: map(),
          body: String.t(),
          status: integer()
        }

  @http_version 1.1

  def to_string(
        %__MODULE__{
          status: status,
          body: body
        } = http_response
      ) do
    """
    HTTP/#{@http_version} #{status}\r
    #{Enum.join(headers_string(http_response), "\r\n")}
    \r
    #{body}
    """
  end

  defp headers_string(http_response) do
    http_response
    |> headers
    |> Enum.map(fn {k, v} ->
      "#{k}: #{v}"
    end)
  end

  defp headers(%__MODULE__{body: body, headers: headers}) do
    headers = prepare_headers(headers)

    body
    |> default_headers()
    |> Map.merge(headers)
  end

  defp default_headers(body) do
    %{
      "content-type" => "text/html",
      "content-length" => byte_size(body)
    }
  end

  defp prepare_headers(headers) do
    headers
    |> Enum.map(fn {k, v} ->
      {String.downcase(k), v}
    end)
    |> Enum.into(%{})
  end
end
