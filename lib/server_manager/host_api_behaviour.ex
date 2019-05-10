defmodule Illithid.ServerManager.HostAPIBehaviour do
  @moduledoc """
  The contract for host apis.
  """

  # TODO(ian): See if we can tighten these return values a little more.
  @callback get_server(String.t()) :: {:ok, Models.Server.t()} | {:error, String.t()}
  @callback list_servers() :: {:ok, [Models.Server.t()]} | {:error, String.t()}
  @callback create_server(map) :: {:ok, Models.Server.t()} | {:error, String.t()}
  @callback destroy_server(Models.Server.t()) :: {:ok, Models.Server.t()} | {:error, String.t()}
end
