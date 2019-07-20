defmodule Illithid.Timers.ServerlessWorkers do
  # TODO(ian): Update when configurable
  @moduledoc """
  Kills worker processes who have no correlated running server
  """
  use GenServer, restart: :transient

  alias Illithid.ServerManager.DigitalOcean.Supervisor
  alias Illithid.ServerManager.Worker

  require Logger

  #######################
  # GenServer Callbacks #
  #######################

  def start_link([api]) do
    GenServer.start_link(__MODULE__, [api])
  end

  def init([api]) do
    state = %{api: api}
    # TODO(ian): Magic number
    Process.send_after(self(), {:kill_orphans, state}, 1000 * 5)
    {:ok, state}
  end

  ################
  # Handle Calls #
  ################
  def handle_info({:kill_orphans, %{api: api} = state}, _state) do
    for server <- find_serverless_workers(api), do: kill_orphan(server)

    {:noreply, state}
  end

  def handle_info(:kill_orphans, %{api: api} = state) do
    for server <- find_serverless_workers(api), do: kill_orphan(server)

    {:noreply, state}
  end

  ######################
  # Internal Functions #
  ######################

  @spec find_serverless_workers(api :: module()) :: [{pid, String.t()}]
  defp find_serverless_workers(api) do
    case api.list_servers() do
      {:ok, servers} ->
        server_names = Enum.map(servers, fn s -> s.name end)

        pids_to_names =
          Enum.map(Supervisor.children(), fn {_, child_pid, _, _} ->
            {child_pid, Worker.get_server_name(child_pid)}
          end)

        retval =
          Enum.filter(
            pids_to_names,
            fn {_pid, name} -> not Enum.member?(server_names, name) end
          )

        retval

      _ ->
        []
    end
  end

  @spec kill_orphan({pid, name :: String.t()}) :: :ok | {:error, atom()} | {:error, String.t()}
  defp kill_orphan({pid, name}) do
    Logger.info("Killing orphaned server #{name}")

    case Supervisor.destroy_server(pid) do
      {:ok, _} -> :ok
      {:error, _} = retval -> retval
    end
  end
end
