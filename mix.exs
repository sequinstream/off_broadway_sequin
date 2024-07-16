defmodule OffBroadwaySequin.MixProject do
  use Mix.Project

  @scm_url "https://github.com/sequinstream/off_broadway_sequin"

  def project do
    [
      app: :off_broadway_sequin,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),

      # Package
      package: package(),
      description: description()
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
      maintainers: ["Sequin"],
      licenses: ["MIT"],
      links: %{GitHub: @scm_url}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:broadway, "~> 1.0"},
      {:req, "~> 0.5.2"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
