defmodule Illithid.ServerManager do
  @moduledoc false
  use Supervisor

  alias ServerManager.Timers.Orphans

  def start_link() do
    start_link([])
  end

  def start_link(_) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_arg) do
    children = [
      {DOSupervisor, []},
      {Orphans, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
