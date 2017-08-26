defmodule Scribe.Mixfile do
  use Mix.Project

  def project do
    [
      app: :scribe,
      version: "0.5.0",
      elixir: "~> 1.3",
      source_url: "https://github.com/codedge-llc/scribe",
      description: description(),
      package: package(),
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      docs: [
        main: "readme", extras: ["README.md"]
      ],
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        "coveralls": :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
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
      {:pane, "~> 0.1"},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:dogma, ">= 0.0.0", only: :dev},
      {:faker, ">= 0.0.0", only: [:dev, :test]},
      {:excoveralls, "~> 0.7", only: :test},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false}
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
