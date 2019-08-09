defmodule BinanceExTest do
  use ExUnit.Case
  doctest Binance

  setup_all do
    HTTPoison.start()
  end

end
