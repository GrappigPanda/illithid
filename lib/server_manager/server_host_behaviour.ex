defmodule Illithid.ServerManager.ServerHostBehaviour do
  @moduledoc """
  Contract for server hosts.
  """

  alias Illithid.ServerManager.Models.Server

  #####################
  # Server Management #
  #####################
  @callback create_server(String.t()) :: {:ok, Server.t()} | {:error, String.t()}
  @callback destroy_server(String.t() | pid()) ::
              {:ok, Server.t()} | {:error, String.t() | :no_running_server}
  @callback server_alive?(pid) :: boolean()
end
