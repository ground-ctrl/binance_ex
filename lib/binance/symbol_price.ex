defmodule Binance.SymbolPrice do
  @moduledoc """
  Retrieve symbols' price from the Binance API.
  According to the documentation, the response looks like:

  {
    "symbol": "LTCBTC",
    "price": "4.00000200"
  }
  """

  defstruct [:symbol, :price]

  def new(response) do
    %Binance.SymbolPrice{
      symbol: response["symbol"],
      price: response["price"] |> String.to_float()
    }
  end
end
