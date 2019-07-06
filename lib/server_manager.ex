defmodule Illithid.ServerManager do
  @moduledoc false
  use Supervisor
  use Application

  alias Illithid.Timers.{Orphans, ServerlessWorkers}
  alias Illithid.ServerManager.DigitalOcean.Supervisor, as: DOSupervisor

  def start(_type, _args) do
    start_link([])
  end

  def start_link(_) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_arg) do
    children = [
      {DOSupervisor, []},
      {Orphans, []},
      {ServerlessWorkers, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
