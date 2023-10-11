defmodule TarotCup.MixProject do
  use Mix.Project

  @version String.trim(File.read!("VERSION"))

  def project do
    [
      app: :tarot_cup,
      compilers: Mix.compilers(),
      deps: deps(),
      elixir: "~> 1.12",
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
      {:faker, "~> 0.11", only: [:dev, :test]},
      {:jason, "~> 1.4"},
      {:nostrum, "~> 0.4"},
      {:opentelemetry, "~> 1.0"},
      {:opentelemetry_api, "~> 1.0"},
      {:opentelemetry_exporter, "~> 1.0"},
      {:persistent_ets, "~> 0.2.0"},
      {:timex, "~> 3.5"},
      {:uuid, "~> 1.1"},

      # ssl_verify_fun 1.1.6 was having issues
      # manually specified to use latest version
      {:ssl_verify_fun, "~> 1.1"}
    ]
  end

  defp releases do
    [
      tarot_cup: [
        applications: [
          opentelemetry_exporter: :permanent,
          opentelemetry: :temporary,
          runtime_tools: :permanent
        ],
        include_executables_for: [:unix],
        path: "dist"
      ]
    ]
  end
end
