defmodule ExTripcode.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_tripcode,
      version: "1.0.2",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "ExTripcode",
      description: "Elixir library for generating tripcodes",
      package: package(),
      source_url: "https://github.com/krepflap/ex_tripcode"
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
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp package() do
    [
      name: "ex_tripcode",
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/krepflap/ex_tripcode"}
    ]
  end
end
