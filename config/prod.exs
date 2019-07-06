use Mix.Config

config :illithid, :digital_ocean, api_module: Illithid.ServerManager.DigitalOcean.API.Prod

config :illithid, :hetzner, api_module: Illithid.ServerManager.Hetzner.API.Prod
