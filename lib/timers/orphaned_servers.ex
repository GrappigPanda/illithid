defmodule Illithid.Timers.OrphanedServers do
  # TODO(ian): Update when update configurable runtime
  @moduledoc """
  Handles killing orphaned child processes.
  """
  use GenServer, restart: :transient

  alias Illithid.ServerManager.DigitalOcean.Supervisor

  require Logger

  #######################
  # GenServer Callbacks #
  #######################

  def start_link([api]) do
    GenServer.start_link(__MODULE__, [api])
  end

  def init([api]) do
    # TODO(ian): Configurable
    state = %{api: api}
    Process.send_after(self(), {:kill_orphans, state}, 1000 * 5)
    {:ok, state}
  end

  ################
  # Handle Calls #
  ################

  def handle_info({:kill_orphans, %{api: api} = state}, _state) do
    for server <- find_orphaned_servers(api), do: kill_orphan(api, server)
    {:noreply, state}
  end

  def handle_info(:kill_orphans, %{api: api} = state) do
    for server <- find_orphaned_servers(api), do: kill_orphan(api, server)
    {:noreply, state}
  end

  ######################
  # Internal Functions #
  ######################

  @spec find_orphaned_servers(api :: module()) :: list | no_return()
  defp find_orphaned_servers(api) do
    servers =
      case api.list_servers() do
        {:ok, servers} when is_list(servers) -> servers
        _ -> []
      end

    server_names = Enum.map(servers, fn s -> s.name end)
    children_names = Supervisor.children_names()

    Enum.filter(server_names, fn s -> s not in children_names end)
  end

  @spec kill_orphan(api :: module(), server_name :: String.t()) :: :ok | {:error, String.t()}
  defp kill_orphan(api, server_name) when is_bitstring(server_name) do
    Logger.info("Killing orphaned server #{server_name}")

    case api.destroy_server(server_name) do
      {:ok, _} -> :ok
      {:error, _} = retval -> retval
    end
  end
end
