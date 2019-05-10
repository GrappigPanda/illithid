defmodule Illithid.ServerManager.ServerHostBehaviour do
  @moduledoc """
  Contract for server hosts.
  """

  alias Illithid.Models

  #####################
  # Server Management #
  #####################
  @callback create_server(number, number) :: {:ok, Models.Server.t()} | {:error, String.t()}
  @callback destroy_server(pid) :: {:ok, Models.Server.t()} | {:error, String.t()}
  @callback server_alive?(pid) :: {:ok, Models.Server.t()} | {:error, String.t()}
end
