defmodule Binance.KLines do
  @moduledoc """
  Retrieve OHLC data from the Binance API. 
  According to the official documentation, the response looks like:

  [
    [
      1499040000000,      // Open time
      "0.01634790",       // Open
      "0.80000000",       // High
      "0.01575800",       // Low
      "0.01577100",       // Close
      "148976.11427815",  // Volume
      1499644799999,      // Close time
      "2434.19055334",    // Quote asset volume
      308,                // Number of trades
      "1756.87402397",    // Taker buy base asset volume
      "28.46694368",      // Taker buy quote asset volume
      "17928899.62484339" // Ignore.
    ]
  ]
  """

  defstruct [
    :open_time,
    :open,
    :high,
    :low,
    :close,
    :volume,
    :close_time,
    :quote_asset_volume,
    :num_trades,
    :taker_buy_base_asset_volume,
    :taker_buy_quote_asset_volume
  ]

  def new(payload) do
    %Binance.KLines{
      open_time: Enum.at(payload, 0),
      open: Enum.at(payload, 1) |> Decimal.new(),
      low: Enum.at(payload, 2) |> Decimal.new(),
      high: Enum.at(payload, 3) |> Decimal.new(),
      close: Enum.at(payload, 4) |> Decimal.new(),
      volume: Enum.at(payload, 5) |> Decimal.new(),
      close_time: Enum.at(payload, 6),
      quote_asset_volume: Enum.at(payload, 7) |> Decimal.new(),
      num_trades: Enum.at(payload, 8),
      taker_buy_base_asset_volume: Enum.at(payload, 9) |> Decimal.new(),
      taker_buy_quote_asset_volume: Enum.at(payload, 10) |> Decimal.new()
    }
  end
end
