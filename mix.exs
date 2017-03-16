defmodule Scribe.Mixfile do
  use Mix.Project

  def project do
    [app: :scribe,
     version: "0.3.0",
     elixir: "~> 1.3",
     source_url: "https://github.com/codedge-llc/scribe",
     description: description(),
     package: package(),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     docs: [main: "readme",
            extras: ["README.md"]]]
  end

  defp description do
    """
    Pretty-print tables of structs and maps
    """
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:pane, "~> 0.1"},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:dogma, ">= 0.0.0", only: :dev}
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
