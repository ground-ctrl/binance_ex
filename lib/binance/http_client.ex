defmodule Binance.HTTPClient do
  @endpoint "https://api.binance.com"

  #
  # GET REQUESTS
  #

  def get(url, headers \\ []) do
    HTTPoison.get("#{@endpoint}#{url}", headers)
    |> parse_binance_response
  end

  def get(url, params, api_key) do
    headers = [{"X-MBX-APIKEY", api_key}]
    arguments = URI.encode_query(params)
    get("#{url}?#{arguments}", headers)
  end

  def get(url, params, api_key, api_secret) do
    headers = [{"X-MBX-APIKEY", api_key}]
    receive_window = 5000
    ts = DateTime.utc_now() |> DateTime.to_unix(:millisecond)

    params =
      Map.merge(params, %{
        timestamp: ts,
        recvWindow: receive_window
      })

    arguments = URI.encode_query(params)

    signature = 
      :crypto.hmac(
        :sha256,
        api_secret,
        arguments
      )
      |> Base.encode16()

    IO.puts("#{@endpoint}#{url}?#{arguments}&signature=#{signature}")
    get("#{url}?#{arguments}&signature=#{signature}", headers)
  end

  #
  # RESPONSE HANDLING
  #

  defp parse_binance_response({:ok, response}) do
    case response.status_code do
      400 ->
        {:error, {:bad_request, response.body |> Jason.decode! |> Map.fetch("message")}}

      401 ->
        {:error, :unauthorized}

      418 ->
        {:error, {:rate_limting, "too many requests: temporary ban"}}

      429 ->
        {:error, {:rate_limiting, "too many requests"}}

      500 ->
        {:error, {:server_error, "server error: request may or may not have been successful"}}

      200 ->
        response.body
        |> Jason.decode()
    end
  end

  defp parse_binance_response({:error, err}) do
    {:error, {:http_error, err}}
  end

end
