defmodule Illithid.ServerManager do
  @moduledoc false
  use Supervisor
  use Application

  alias Illithid.Constants.Hosts
  alias Illithid.Timers.{OrphanedServers, ServerlessWorkers}
  alias Illithid.ServerManager.DigitalOcean.Supervisor, as: DOSupervisor
  alias Illithid.ServerManager.Hetzner.Supervisor, as: HetznerSupervisor

  @digital_ocean_api Application.get_env(:illithid, Hosts.digital_ocean())[:api_module]
  @hetzner_api Application.get_env(:illithid, Hosts.hetzner())[:api_module]

  @hosts_to_api %{Hosts.digital_ocean() => @digital_ocean_api, Hosts.hetzner() => @hetzner_api}

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
      {HetznerSupervisor, []}
    ] ++ filter_supervisors_for_active_hosts()
  end

  @spec filter_supervisors_for_active_hosts() :: [any()]
  defp filter_supervisors_for_active_hosts do
    Hosts.all_hosts()
    |> Enum.flat_map(fn host when is_atom(host) ->
      case Application.get_env(:illithid, host)[:auth_token] do
        token when is_binary(token) ->
          api = @hosts_to_api[host]

          [
            Supervisor.child_spec({ServerlessWorkers, [api]},
              id: Atom.to_string(host) <> "-serverless-workers"
            ),
            Supervisor.child_spec({OrphanedServers, [api]},
              id: Atom.to_string(host) <> "-orphaned-servers"
            )
          ]

        _ ->
          []
      end
    end)
  end
end
