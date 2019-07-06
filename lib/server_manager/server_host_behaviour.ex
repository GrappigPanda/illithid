defmodule Illithid.ServerManager.ServerHostBehaviour do
  @moduledoc """
  Contract for server hosts.
  """

  alias Illithid.Models.{Server, ServerCreationContext}

  #####################
  # Server Management #
  #####################
  @callback create_server(ServerCreationContext.t()) :: {:ok, Server.t()} | {:error, String.t()}
  @callback destroy_server(String.t() | pid()) ::
              {:ok, Server.t()} | {:error, String.t() | :no_running_server}
  @callback server_alive?(pid) :: boolean()
end
