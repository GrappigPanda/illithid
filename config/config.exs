use Mix.Config

import_config "#{Mix.env()}.exs"

config :illithid, :runtime_env, Mix.env()

if Mix.env() == :prod do
  import_config "#{Mix.env()}.secret.exs"
end
