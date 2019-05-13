defmodule Illithid.ServerManager.DigitalOcean.API.Dev do
  @behaviour Illithid.ServerManager.HostAPIBehaviour
  @moduledoc """
  The production API handler
  """

  alias Jason
  alias Illithid.ServerManager.Models

  require Logger

  @spec get_server(server_id :: String.t()) :: {:ok, Models.Server.t()} | {:error, String.t()}
  def get_server(server_id) do
    case server_id do
      "trigger-failure" ->
        {:error, "Failed to get server"}

      _ ->
        {:ok, mock_server()}
    end
  end

  @spec list_servers() :: {:ok, [Models.Server.t()]} | {:error, String.t()}
  def list_servers(opts \\ [fail: false]) do
    case Access.get(opts, :fail) do
      true ->
        {:ok, [mock_server(), mock_server()]}

      _ ->
        {:error, "Failed to list servers"}
    end
  end

  @spec create_server(map) :: {:ok, Models.Server.t()} | {:error, String.t()}
  def create_server(%{
        "name" => name,
        "region" => _region,
        "size" => _size,
        "image" => _image
      }) do
    case name do
      "trigger-failure" ->
        {:error, "Failed to start server"}

      _ ->
        {:ok, mock_server()}
    end
  end

  @spec destroy_server(String.t() | Models.Server.t()) ::
          {:ok, Models.Server.t()} | {:error, String.t()}
  def destroy_server(server_name) when is_binary(server_name) do
    case server_name do
      "trigger-value" ->
        {:error, "Failed to destroy server"}

      _ ->
        {:ok, mock_server()}
    end
  end

  def destroy_server(%Models.Server{name: name}) do
    case name do
      "trigger-value" ->
        {:error, "Failed to destroy server"}

      _ ->
        {:ok, mock_server()}
    end
  end

  @spec server_alive?(Models.Server.t()) :: boolean
  def server_alive?(%Models.Server{id: _server_id}) do
    true
  end

  @spec mock_server(server_name :: String.t()) :: Models.Server.t()
  defp mock_server(server_name \\ "test_name") do
    %Models.Server{
      id: "0",
      ip: "127.0.0.1",
      name: server_name,
      region: "NYC",
      memory: "4gb",
      vcpus: "4",
      disk: "100gb",
      host: :digital_ocean,
      status: "started",
      state: :started,
      image: "test/001"
    }
  end
end
