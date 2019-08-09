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
      free: payload["free"] |> String.to_float(),
      locked: payload["locked"] |> String.to_float()
    }
  end
end
