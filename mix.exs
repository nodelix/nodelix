defmodule Nodelix.MixProject do
  use Mix.Project

  @version "1.0.0-alpha.3"
  @source_url "https://github.com/sheerlox/nodelix"

  def project do
    [
      app: :nodelix,
      version: @version,
      elixir: "~> 1.12.3 or ~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      docs: docs(),
      aliases: [test: ["nodelix.install --if-missing", "test"]]
    ]
  end

  defp description() do
    """
    Seamless Node.js in Elixir.
    """
  end

  defp package() do
    [
      maintainers: ["Pierre Cavin"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp docs() do
    [
      name: "Nodelix",
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}",
      canonical: "http://hexdocs.pm/nodelix",
      extras: ["README.md", "CHANGELOG.md", "LICENSE.md"]
    ]
  end

  def application do
    [
      extra_applications: [:logger, inets: :optional, ssl: :optional],
      mod: {Nodelix, []},
      env: [default: []]
    ]
  end

  defp deps do
    [
      {:gpg_ex, "1.0.0-alpha.3"},
      {:castore, "~> 1.0"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
