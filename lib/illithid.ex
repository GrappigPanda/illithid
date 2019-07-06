defmodule Illithid do
  @moduledoc """
  Documentation for Illithid.
  """

  alias Illithid.Constants.Hosts
  alias Illithid.Models.ServerCreationContext

  @doc """
  Creates and monitors a server
  """
  @spec create_server(ServerCreationContext.t()) :: {:ok, pid} | {:error, binary()}
  def create_server(%ServerCreationContext{host: host} = scc) do
    with {:ok, supervisor} <- Hosts.resolve_supervisor_from_host(host) do
      supervisor.create_server(scc)
    end
  end
end
