defmodule Illithid.ServerManager do
  @moduledoc false
  use Supervisor
  use Application

  alias Illithid.Timers.{Orphans, ServerlessWorkers}
  alias Illithid.ServerManager.DigitalOcean.Supervisor, as: DOSupervisor
  alias Illithid.ServerManager.Hetzner.Supervisor, as: HetznerSupervisor

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
      {Orphans, []},
      {ServerlessWorkers, []}
    ]
  end
end
