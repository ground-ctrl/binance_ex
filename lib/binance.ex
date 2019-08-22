defmodule Binance do
  alias Binance.HTTPClient

  defstruct [:api_key, :api_secret]

  @moduledoc """
  The official documentation for the Binance REST API can be found at:
  https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md
  """

  def ping() do
    HTTPClient.get('/api/v1/ping')
  end

  @doc """
  Latest price for a symbol (or symbols).

  If the symbol is not specified the API will return the price for all symbols
  in an array.
  """

  def price(symbol) do
    params = %{symbol: symbol}
    api_key = Application.get_env(:binance_api, :api_key)

    case HTTPClient.get("/api/v3/ticker/price", params, api_key) do
      {:ok, price} -> {:ok, Binance.SymbolPrice.new(price)}
      err -> err
    end
  end

  def price() do
    params = %{}
    api_key = Application.get_env(:binance_api, :api_key)

    case HTTPClient.get("/api/v3/ticker/price", params, api_key) do
      {:ok, prices} -> {:ok, Enum.map(prices, fn x -> Binance.SymbolPrice.new(x) end)}
      err -> err
    end
  end

  @doc """
  Current account information
  """

  def account(receive_window, timestamp) do
    api_key = Application.get_env(:binance_api, :api_key)
    api_secret = Application.get_env(:binance_api, :api_secret)

    case HTTPClient.get("/api/v3/account", %{}, api_key, api_secret) do
      {:ok, info} -> {:ok, Binance.Account.new(info)}
      err -> err
    end
  end

  def account() do
    ts = DateTime.utc_now() |> DateTime.to_unix(:millisecond)
    account_information(5000, ts)
  end

  @doc """
  Kline/Candlestick data for a symbol. To follow usual naming conventions
  we expose this endpoint through a function called `ohlc`.

  The API takes the following arguments:
  - symbol
  - interval_length (see reference for available options)
  - start_time (optional)
  - end_time (optional)
  - limit (optional, default 500, maximum 1000)

  The API returns the most recent data points if neither `start_time` nor
  `end_time` are sent.

  Klines are uniquely defined by their open time.
  """

  def klines(symbol, interval, start_time \\ nil , end_time \\ nil, limit \\ 500) do
    params = kline_params(symbol, interval, limit, start_time, end_time)
    api_key = Application.get_env(:binance_api, :api_key)

    case HTTPClient.get("/api/v1/klines", params, api_key) do
      {:ok, klines} -> {:ok, Enum.map(klines, fn x -> Binance.KLines.new(x) end)}
      err -> err
    end
  end

  defp klines_params(symbol, interval, limit, start_time, end_time)
       when is_nil(start_time) and
              is_nil(end_time) do
    %{
      symbol: symbol,
      interval: interval,
      limit: limit
    }
  end

  defp klines_params(symbol, interval, limit, start_time, end_time)
       when is_nil(end_time) do
    %{
      symbol: symbol,
      interval: interval,
      limit: limit,
      startTime: start_time
    }
  end

  defp klines_params(symbol, interval, limit, start_time, end_time) do
    %{
      symbol: symbol,
      interval: interval,
      limit: limit,
      startTime: start_time,
      endTime: end_time
    }
  end
end
