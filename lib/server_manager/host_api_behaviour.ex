defmodule Illithid.ServerManager.HostAPIBehaviour do
  @moduledoc """
  The contract for host apis.
  """

  alias Illithid.ServerManager.Models.Server

  # TODO(ian): See if we can tighten these return values a little more.
  @callback get_server(String.t()) :: {:ok, Server.t()} | {:error, String.t()}
  @callback list_servers() :: {:ok, [Server.t()]} | {:error, String.t()}
  @callback create_server(map) :: {:ok, Server.t()} | {:error, String.t()}
  @callback destroy_server(Server.t()) :: {:ok, Server.t()} | {:error, String.t()}
end
