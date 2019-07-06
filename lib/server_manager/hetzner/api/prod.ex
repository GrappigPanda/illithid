defmodule Illithid.ServerManager.Hetzner.API.Prod do
  @behaviour Illithid.ServerManager.HostAPIBehaviour
  @moduledoc """
  The production API handler
  """

  alias Jason
  alias Illithid.Constants.Hosts
  alias Illithid.Utils.BaseAPI
  alias Illithid.Models.Server

  require Logger

  @url "https://api.hetzner.cloud/v1/"
  @server_url @url <> "servers/"
  @running_statuses ["running", "initializing", "starting", "migrating", "rebuilding"]

  @spec get_server(server_id :: String.t()) :: {:ok, Server.t()} | {:error, String.t()}
  def get_server(server_id) when is_bitstring(server_id) do
    case BaseAPI.get(@server_url <> server_id, request_headers()) do
      {:ok, %HTTPoison.Response{body: response}} ->
        server =
          response
          |> Jason.decode!()
          |> Map.get("server")
          |> server_from_map()

        {:ok, server}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  @spec list_servers() :: {:ok, [Server.t()]} | {:error, String.t()}
  def list_servers() do
    case BaseAPI.get(@server_url, request_headers()) do
      {:ok, %HTTPoison.Response{body: response}} ->
        server =
          response
          |> Jason.decode!()
          |> Map.get("servers")
          |> Enum.map(&server_from_map/1)

        {:ok, server}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  @spec create_server(map) :: {:ok, Server.t()} | {:error, String.t()}
  def create_server(
        %{
          "name" => _name,
          "server_type" => _server_type,
          "image" => _image
        } = request
      ) do
    case BaseAPI.post(@server_url, Jason.encode!(request), request_headers()) do
      {:ok, %HTTPoison.Response{body: response}} ->
        server =
          response
          |> Jason.decode!()
          |> Map.get("server")
          |> server_from_map()

        {:ok, server}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  @spec destroy_server(String.t() | Server.t()) :: {:ok, Server.t()} | {:error, String.t()}
  def destroy_server(server_id) when is_binary(server_id) do
    case BaseAPI.delete(@server_url <> server_id, request_headers()) do
      {:ok, %HTTPoison.Response{body: response}} ->
        server =
          response
          |> Jason.decode!()
          |> Map.get("server")
          |> server_from_map()

        {:ok, server}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def destroy_server(%Server{id: server_id}) do
    server_id_str = Integer.to_string(server_id)

    with {:ok, server} <- get_server(server_id_str) do
      case BaseAPI.delete(@server_url <> Integer.to_string(server_id), request_headers()) do
        {:ok, %HTTPoison.Response{}} ->
          {:ok, server}

        {:error, %HTTPoison.Error{reason: reason}} ->
          {:error, reason}
      end
    end
  end

  @spec server_alive?(Server.t()) :: boolean
  def server_alive?(%Server{id: server_id}) do
    case get_server(Integer.to_string(server_id)) do
      {:ok, %Server{status: status}} ->
        Enum.member?(@running_statuses, status)

      retval ->
        retval
    end
  end

  @spec list_images(list_local :: bool()) :: {:ok, map()} | {:error, atom()}
  def list_images(_list_local \\ true) do
    case BaseAPI.get(@url <> "images?status=available", request_headers()) do
      {:ok, %HTTPoison.Response{body: response}} ->
        {:ok, Jason.decode!(response)}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  @spec server_from_map(map()) :: Server.t()
  def server_from_map(%{} = server) do
    Server.new(
      server["id"],
      server["public_net"]["ipv4"]["ip"],
      server["name"],
      server["datacenter"]["location"]["name"],
      server["server_type"]["memory"],
      server["server_type"]["cpus"],
      server["server_type"]["disk"],
      Hosts.hetzner(),
      server["status"],
      # TODO(ian): Make a state machine and call state_machine.initial() instead
      :started,
      server["image"]["name"]
    )
  end

  @spec request_headers() :: [tuple()]
  defp request_headers,
    do: [Authorization: "Bearer #{auth_token()}", "Content-Type": "application/json"]

  @spec auth_token() :: String.t()
  defp auth_token, do: Application.get_env(:illithid, :hetzner)[:auth_token]
end
