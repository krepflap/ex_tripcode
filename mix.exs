defmodule ExTripcode.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_tripcode,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:crypt3, "~> 1.0"},
      {:iconv, "~> 1.0"},
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
    ]
  end
end
