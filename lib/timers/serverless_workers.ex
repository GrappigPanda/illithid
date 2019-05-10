defmodule Illithid.Timers.ServerlessWorkers do
  # TODO(ian): Update when configurable
  @moduledoc """
  Kills worker processes who have no correlated running server
  """
  use GenServer, restart: :transient

  @api Application.get_env(:illithid, :digital_ocean)[:api_module]

  alias Illithid.ServerManager.DigitalOcean.{Supervisor, Worker}

  require Logger

  #######################
  # GenServer Callbacks #
  #######################

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    # TODO(ian): Magic number
    Process.send_after(self(), :kill_orphans, 1000 * 5)
    {:ok, %{}}
  end

  ################
  # Handle Calls #
  ################

  def handle_info(:kill_orphans, state) do
    for server <- find_serverless_workers(), do: kill_orphan(server)
    {:noreply, state}
  end

  ######################
  # Internal Functions #
  ######################

  @spec find_serverless_workers() :: list
  defp find_serverless_workers() do
    servers =
      case @api.list_servers() do
        {:ok, servers} -> servers
        _ -> []
      end

    server_names = Enum.map(servers, fn s -> s.name end)

    pids_to_names =
      Enum.map(Supervisor.children(), fn {_, child_pid, _, _} ->
        {child_pid, Worker.get_server_name(child_pid)}
      end)

    Enum.filter(pids_to_names, fn {_, name} -> name not in server_names end)
  end

  @spec kill_orphan(pid) :: :ok | {:error, String.t()}
  defp kill_orphan({pid, name}) do
    Logger.info("Killing orphaned server #{name}")

    case Supervisor.destroy_server(pid) do
      {:ok, _} -> :ok
      {:error, _} = retval -> retval
    end
  end
end
