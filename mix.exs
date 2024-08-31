defmodule Scribe.Mixfile do
  use Mix.Project

  @version "0.10.0"

  def project do
    [
      app: :scribe,
      version: @version,
      elixir: "~> 1.13",
      source_url: "https://github.com/codedge-llc/scribe",
      description: description(),
      package: package(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [
        main: "readme",
        extras: ["README.md"]
      ],
      dialyzer: [
        plt_add_deps: true
      ]
    ]
  end

  defp description do
    """
    Pretty-print tables of structs and maps
    """
  end

  def application do
    [applications: [:logger, :pane]]
  end

  defp deps do
    [
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:faker, "~> 0.9", only: [:dev, :test]},
      {:pane, "~> 0.2"}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Henry Popp"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/codedge-llc/scribe"}
    ]
  end
end
