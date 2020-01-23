use Mix.Config

config :illithid, :digital_ocean, api_module: Illithid.ServerManager.DigitalOcean.API.Dev
config :illithid, :digital_ocean, auth_token: nil

config :illithid, :hetzner, api_module: Illithid.ServerManager.Hetzner.API.Dev
config :illithid, :hetzner, auth_token: nil
