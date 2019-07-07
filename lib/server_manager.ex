defmodule Illithid.ServerManager do
  @moduledoc false
  use Supervisor
  use Application

  alias Illithid.Constants.Hosts
  alias Illithid.Timers.{OrphanedServers, ServerlessWorkers}
  alias Illithid.ServerManager.DigitalOcean.Supervisor, as: DOSupervisor
  alias Illithid.ServerManager.Hetzner.Supervisor, as: HetznerSupervisor

  @digital_ocean_api Application.get_env(:illithid, :digital_ocean)[:api_module]
  @hetzner_api Application.get_env(:illithid, :hetzner)[:api_module]

  def start(_type, _args) do
    start_link([])
  end

  def start_link(_) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_arg) do
    children =
      case Application.get_env(:illithid, :runtime_env) do
        :dev ->
          all_children()

        :test ->
          []

        :prod ->
          all_children()
      end

    Supervisor.init(children, strategy: :one_for_one)
  end

  @spec all_children() :: [{module(), list()}]
  def all_children do
    [
      {DOSupervisor, []},
      {HetznerSupervisor, []},
      Supervisor.child_spec({ServerlessWorkers, [@digital_ocean_api]},
        id: Atom.to_string(Hosts.digital_ocean()) <> "-serverless-workers"
      ),
      Supervisor.child_spec({ServerlessWorkers, [@hetzner_api]},
        id: Atom.to_string(Hosts.hetzner()) <> "-serverless-workers"
      ),
      Supervisor.child_spec({OrphanedServers, [@digital_ocean_api]},
        id: Atom.to_string(Hosts.digital_ocean()) <> "-orphaned-servers"
      ),
      Supervisor.child_spec({OrphanedServers, [@hetzner_api]},
        id: Atom.to_string(Hosts.hetzner()) <> "-orphaned-servers"
      )
    ]
  end
end
