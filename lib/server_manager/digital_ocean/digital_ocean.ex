defmodule Illithid.ServerManager.DigitalOcean.Supervisor do
  @moduledoc false
  @behaviour Illithid.ServerManager.ServerHostBehaviour

  use DynamicSupervisor

  alias Illithid.Models
  alias Illithid.ServerManager.DigitalOcean.Worker
  alias Illithid.ServerManager.DigitalOcean.Regions

  ###############################
  # DynamicSupervisor Callbacks #
  ###############################

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  ########################
  # BuildServerHost Callbacks #
  ########################

  @spec create_server(String.t(), String.t()) :: {:ok, Models.Server.t()} | {:error, String.t()}
  def create_server(build_id, build_definition) do
    child_spec = {Worker, {build_id, choose_region(), build_definition}}

    case DynamicSupervisor.start_child(__MODULE__, child_spec) do
      {:ok, child_pid} = retval ->
        GenServer.call(child_pid, :check_server_status)
        retval

      {:error, error_reason} ->
        # TODO(ian): Do something about below error
        {:error, inspect(error_reason)}
    end
  end

  @spec destroy_server(server_id :: pid() | String.t()) ::
          {:ok, Models.Server.t()} | {:error, :no_running_server}
  def destroy_server(server_id) when is_binary(server_id) do
    __MODULE__.children_names_to_pids()[server_id]
    |> __MODULE__.destroy_server()
  end

  def destroy_server(nil) do
    {:error, :no_running_server}
  end

  def destroy_server(server_pid) do
    Worker.destroy_server(server_pid)
  end

  @spec server_alive?(String.t()) :: :ok | :error
  def server_alive?(server_id) when is_binary(server_id) do
    __MODULE__.children_names_to_pids()[server_id]
    |> __MODULE__.server_alive?()
  end

  @spec server_alive?(pid) :: :ok | :error
  def server_alive?(server_pid) do
    Worker.server_alive?(server_pid)
  end

  @spec get_server(String.t()) :: {:ok, Models.Server.t()} | {:error, String.t()}
  def get_server(server_name) when is_binary(server_name) do
    __MODULE__.children_names_to_pids()[server_name]
    |> __MODULE__.get_server()
  end

  @spec get_server(pid) :: {:ok, Models.Server.t()} | {:error, String.t()}
  def get_server(pid) do
    Worker.get_server_from_process(pid)
  end

  @spec children() :: [Worker]
  def children do
    DynamicSupervisor.which_children(__MODULE__)
  end

  @spec count_children() :: number
  def count_children do
    DynamicSupervisor.count_children(__MODULE__)
  end

  @spec children_names() :: [String.t()]
  def children_names() do
    Enum.map(__MODULE__.children(), fn {_, pid, _, _} -> Worker.get_server_name(pid) end)
  end

  @spec children_names_to_pids() :: map
  def children_names_to_pids() do
    Enum.into(__MODULE__.children(), %{}, fn {_, pid, _, _} ->
      {Worker.get_server_name(pid), pid}
    end)
  end

  ###########################
  # Private Utility Methods #
  ###########################

  @spec choose_region() :: String.t()
  defp choose_region() do
    # TODO(ian): Do this a little better
    Regions.all_available_regions()
    |> hd()
  end
end
