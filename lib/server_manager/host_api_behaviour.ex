defmodule Illithid.ServerManager.HostAPIBehaviour do
  @moduledoc """
  The contract for host apis.
  """

  alias Illithid.Models.{Server, ServerCreationContext}

  # TODO(ian): See if we can tighten these return values a little more.
  @callback get_server(String.t()) :: {:ok, Server.t()} | {:error, String.t()}
  @callback list_servers() :: {:ok, [Server.t()]} | {:error, String.t()}
  @callback list_images(bool) :: {:ok, map()} | {:error, atom()}
  @callback create_server(ServerCreationContext.t()) :: {:ok, Server.t()} | {:error, String.t()}
  @callback destroy_server(String.t() | Server.t()) :: {:ok, Server.t()} | {:error, String.t()}
  @callback server_alive?(Server.t()) :: boolean()
end
