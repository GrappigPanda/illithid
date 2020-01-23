defmodule Illithid do
  @moduledoc """
  Documentation for Illithid.
  """

  alias Illithid.Constants.Hosts
  alias Illithid.Models.{Region, ServerCreationContext}

  @doc """
  Creates and monitors a server
  """
  @spec create_server(ServerCreationContext.t()) :: {:ok, pid} | {:error, binary()}
  def create_server(%ServerCreationContext{host: host} = scc) do
    with {:ok, supervisor} <- Hosts.resolve_supervisor_from_host(host),
         true <- valid_region?(scc.region, host) do
      supervisor.create_server(scc)
    end
  end

  #####################
  # Private Functions #
  #####################

  @spec valid_region?(region :: String.t(), host :: atom()) :: bool | {:error, atom()}
  defp valid_region?(region, host) when is_binary(region) and is_atom(host) do
    api = Hosts.api_for_host(host)

    api.list_locations()
    |> case do
      {:ok, regions} ->
        regions
        |> Enum.map(fn %Region{slug: slug} -> slug end)

      _error ->
        {:error, :invalid_region_for_host}
    end
    |> Enum.member?(region)
    |> case do
      true ->
        true

      false ->
        {:error, :invalid_region_for_host}
    end
  end
end
