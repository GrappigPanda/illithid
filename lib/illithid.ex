defmodule Illithid do
  @moduledoc """
  Documentation for Illithid.
  """

  alias Illithid.Models.ServerCreationContext
  alias Illithid.ServerManager.DigitalOcean.Supervisor, as: DOSupervisor

  @doc """
  Creates and monitors a server
  """
  @spec create_server(ServerCreationContext.t()) :: {:ok, pid} | {:error, binary()}
  def create_server(%ServerCreationContext{host: host} = scc) do
    with {:ok, supervisor} <- resolve_supervisor_from_host(host) do
      supervisor.create_server(scc)
    end
  end

  @spec resolve_supervisor_from_host(:digital_ocean | atom()) :: {:ok, DOSupervisor}
  defp resolve_supervisor_from_host(host) when is_atom(host) do
    case host do
      :digital_ocean -> {:ok, DOSupervisor}
    end
  end
end
