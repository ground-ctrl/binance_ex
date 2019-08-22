defmodule Binance.Balance do

  @moduledoc """
  Data structure that represents a balance
  """

  defstruct [
    :asset,
    :free,
    :locked
  ]

  def new(payload) do
    %Binance.Balance{
      asset: payload["asset"],
      free: payload["free"] |> Decimal.new(),
      locked: payload["locked"] |> Decimal.new()
    }
  end
end
