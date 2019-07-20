defmodule Illithid.MixProject do
  use Mix.Project

  def project do
    [
      app: :illithid,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      aliases: aliases(),
      elixirc_options: [warnings_as_errors: true],
      dialyzer: [
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Illithid.ServerManager, []}
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.5"},
      {:timex, "~> 3.1"},
      {:jason, "~> 1.1"},
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.14", only: :dev, runtime: false}
    ]
  end

  defp aliases do
    [
      testall: ["credo", "test", "dialyzer"]
    ]
  end

  defp description do
    "Programatically spawn and manage server infrastructure"
  end

  defp package do
    [
      name: "illithid",
      files: ["lib", "mix.exs", "README.*", "LICENSE"],
      maintainers: ["Ian Lee Clark"],
      licenses: ["BSD"],
      links: %{"Github" => "https://github.com/ianleeclark/illithid"}
    ]
  end
end
