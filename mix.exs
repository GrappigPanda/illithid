defmodule Illithid.MixProject do
  use Mix.Project

  def project do
    [
      app: :illithid,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_options: [warnings_as_errors: true]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [{:httpoison, "~> 1.5"}, {:timex, "~> 3.1"}, {:jason, "~> 1.1"}]
  end
end
