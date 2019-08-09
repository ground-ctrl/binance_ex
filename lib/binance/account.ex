defmodule Binance.Account do
  alias Binance.Balance

  @moduledoc """
  Retrieve account information from the Binance API.
  According to the documentation, the response looks like:

  {
    "makerCommission": 15,
    "takerCommission": 15,
    "buyerCommission": 0,
    "sellerCommission": 0,
    "canTrade": true,
    "canWithdraw": true,
    "canDeposit": true,
    "updateTime": 123456789,
    "balances": [
      {
        "asset": "BTC",
        "free": "4723846.89208129",
        "locked": "0.00000000"
      },
      {
        "asset": "LTC",
        "free": "4763368.68006011",
        "locked": "0.00000000"
      }
    ]
  }
  """

  defstruct [
    :maker_commission,
    :taker_commission,
    :buyer_commission,
    :seller_commission,
    :can_trade,
    :can_withdraw,
    :can_deposit,
    :update_time,
    :balances
  ]

  def new(payload) do
    %Binance.Account{
      maker_commission: payload["makerCommission"],
      taker_commission: payload["takerCommission"],
      buyer_commission: payload["buyerCommission"],
      seller_commission: payload["sellerCommission"],
      can_trade: payload["canTrade"],
      can_withdraw: payload["canWithdraw"],
      can_deposit: payload["canDeposit"],
      update_time: payload["updateTime"],
      balances: Enum.map(payload["balances"], fn x -> Balance.new(x) end)
    }
 end

end
