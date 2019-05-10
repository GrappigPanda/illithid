defmodule Illithid.Timers.ExcessRuntime do
  # TODO(ian): Update this module doc with info on how to configure
  @moduledoc """
  Kills servers which have been running for too long
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
    # TODO(ian): Configure this
    Process.send_after(self(), :kill_excess, 1000 * 5)
    {:ok, %{}}
  end

  ################
  # Handle Calls #
  ################

  def handle_info(:kill_excess, state) do
    for server <- find_excess_servers(), do: terminate_worker(server)

    {:noreply, state}
  end

  ######################
  # Internal Functions #
  ######################

  @spec find_excess_servers() :: [{pid(), String.t()}]
  defp find_excess_servers() do
    servers =
      case @api.list_servers() do
        {:ok, servers} -> servers
        _ -> []
      end

    long_running_servers =
      Enum.map(
        Enum.filter(servers, fn s ->
          s.created_at >= Timex.shift(Timex.now(:utc), hours: 1)
        end),
        fn s -> s.name end
      )

    pids_to_names =
      Enum.map(Supervisor.children(), fn {_, child_pid, _, _} ->
        {child_pid, Worker.get_server_name(child_pid)}
      end)

    Enum.filter(pids_to_names, fn {_, name} ->
      name not in long_running_servers
    end)
  end

  @spec terminate_worker(String.t()) :: :ok | {:error, String.t()}
  defp terminate_worker({pid, name}) do
    Logger.info("Killing overly long build process #{name}")

    case Supervisor.destroy_server(pid) do
      {:ok, _} ->
        :ok

      {:error, reason} = retval ->
        Logger.error("Failed to destroy server for pid #{inspect(pid)} because of #{reason}.")
        retval
    end
  end
end
