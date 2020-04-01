defmodule TarotCup.MixProject do
  use Mix.Project

  @version String.trim(File.read!("VERSION"))

  def project do
    [
      app: :tarot_cup,
      compilers: Mix.compilers(),
      deps: deps(),
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      releases: releases(),
      start_permanent: Mix.env() == :prod,
      version: @version
    ]
  end

  def application do
    [
      mod: {TarotCup.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:alchemy,
       git: "https://github.com/cronokirby/alchemy.git",
       ref: "d72ecb0f1a1b71f65cc748efd229df873893a43f"},
      {:faker, "~> 0.11", only: [:dev, :test]},
      {:poison, "~> 4.0"},
      {:timex, "~> 3.5"},
      {:uuid, "~> 1.1"}
    ]
  end

  defp releases do
    [
      tarot_cup: [
        applications: [
          runtime_tools: :permanent
        ],
        include_executables_for: [:unix],
        path: "dist"
      ]
    ]
  end
end
