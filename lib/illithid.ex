defmodule Illithid do
  @moduledoc """
  Documentation for Illithid.
  """

  alias Illithid.ServerManager.Models.Server
  alias Illithid.ServerManager.Models.ServerCreationContext
  alias Illithid.ServerManager.DigitalOcean.Supervisor, as: DOSupervisor

  @doc """
  Creates and monitors a server
  """
  @spec create_server(ServerCreationContext.t()) :: any()
  def create_server(%ServerCreationContext{server_id: server_id, host: host}) do
    with {:ok, supervisor} <- resolve_supervisor_from_host(host),
         {:ok, %Server{} = new_server} <- supervisor.create_server(server_id) do
      {:ok, new_server}
    end
  end

  @spec resolve_supervisor_from_host(:digital_ocean | atom()) :: any() | {:error, :invalid_host}
  defp resolve_supervisor_from_host(host) when is_atom(host) do
    case host do
      :digital_ocean -> DOSupervisor
      _ -> {:error, :invalid_host}
    end
  end
end
