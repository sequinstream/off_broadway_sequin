defmodule OffBroadwaySequin.MixProject do
  use Mix.Project

  @github "https://github.com/sequinstream/off_broadway_sequin"

  def project do
    [
      app: :off_broadway_sequin,
      version: "0.1.3",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),

      # Package
      package: package(),
      description: description(),
      source_url: @github
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description do
    "A Sequin consumer for Broadway"
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{GitHub: @github},
      maintainers: ["Anthony Accomazzo", "Carter Pedersen"]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:broadway, "~> 1.0"},
      {:req, "~> 0.5.2"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
