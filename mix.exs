defmodule BinanceEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :binance_ex,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.5"},
      {:jason, "~> 1.1"},
    ]
  end

  defp description do
    """
    Elixir wrapper for Binance's REST API
    """
  end

  defp package do
    [
      licenses: ["MIT"],
      maintainers: ["Rémi Louf"],
      name: :binance_ex,
    ]
  end
end
