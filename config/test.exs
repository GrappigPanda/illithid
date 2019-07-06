use Mix.Config

config :illithid, :digital_ocean, api_module: Illithid.ServerManager.DigitalOcean.API.Dev

config :illithid, :illithid, api_module: Illithid.ServerManager.Hetzner.API.Dev
