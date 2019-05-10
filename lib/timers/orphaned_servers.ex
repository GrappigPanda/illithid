defmodule Illithid.Timers.Orphans do
  # TODO(ian): Update when update configurable runtime
  @moduledoc """
  Handles killing orphaned child processes.
  """
  use GenServer, restart: :transient

  @api Application.get_env(:illithid, :digital_ocean)[:api_module]

  alias Illithid.ServerManager.DigitalOcean.Supervisor

  require Logger

  #######################
  # GenServer Callbacks #
  #######################

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    # TODO(ian): Configurable
    Process.send_after(self(), :kill_orphans, 1000 * 5)
    {:ok, %{}}
  end

  ################
  # Handle Calls #
  ################

  def handle_info(:kill_orphans, state) do
    Enum.map(find_orphaned_servers(), &kill_orphan/1)
    {:noreply, state}
  end

  ######################
  # Internal Functions #
  ######################

  @spec find_orphaned_servers() :: list
  defp find_orphaned_servers() do
    servers =
      case @api.list_servers() do
        {:ok, nil} -> []
        {:ok, servers} -> servers
        _ -> []
      end

    server_names = Enum.map(servers, fn s -> s.name end)
    children_names = Supervisor.children_names()

    Enum.filter(server_names, fn s -> s not in children_names end)
  end

  @spec kill_orphan(String.t()) :: :ok | {:error, String.t()}
  defp kill_orphan(server_name) do
    Logger.info("Killing orphaned server #{server_name}")

    case @api.destroy_server(server_name) do
      {:ok, _} -> :ok
      {:error, _} = retval -> retval
    end
  end
end
