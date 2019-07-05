use Mix.Config

import_config "#{Mix.env()}.exs"

if Mix.env() == :prod do
  import_config "#{Mix.env()}.secret.exs"
end
