defmodule Illithid.ServerManager.DigitalOcean.API.Prod do
  @behaviour Illithid.ServerManager.HostAPIBehaviour
  @moduledoc """
  The production API handler
  """
  # TODO(ian): Make this into a behaviour

  alias Jason
  alias Illithid.Utils.BaseAPI
  alias Illithid.Models

  require Logger

  @url "https://api.digitalocean.com/v2/"
  @droplets_url @url <> "droplets/"

  @spec get_server(server_id :: String.t()) :: {:ok, Models.Server.t()} | {:error, String.t()}
  def get_server(server_id) do
    case BaseAPI.get(@droplets_url <> server_id, request_headers()) do
      {:ok, %HTTPoison.Response{body: response}} ->
        server =
          response
          |> Jason.decode!()
          |> from_droplet()

        {:ok, server}

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("Failed to get digital ocean server by id (#{server_id}) because #{reason}")
        {:error, reason}
    end
  end

  @spec list_servers() :: {:ok, [Models.Server.t()]} | {:error, String.t()}
  def list_servers() do
    case BaseAPI.get(@droplets_url, request_headers()) do
      {:ok, %HTTPoison.Response{body: response}} ->
        servers =
          response
          |> Jason.decode!()
          |> Map.get("droplets", [])
          |> Enum.map(fn droplet -> from_droplet(droplet) end)

        {:ok, servers}

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("Failed to get digital ocean servers because #{reason}")
        {:error, reason}
    end
  end

  @spec create_server(map) :: {:ok, Models.Server.t()} | {:error, String.t()}
  def create_server(
        %{
          "name" => _name,
          "region" => _region,
          "size" => _size,
          "image" => _image
        } = request
      ) do
    case BaseAPI.post(@droplets_url, Jason.encode!(request), request_headers()) do
      {:ok, %HTTPoison.Response{body: response, status_code: 202}} ->
        server =
          response
          |> Jason.decode!()
          |> from_droplet()

        {:ok, server}

      {:ok, %HTTPoison.Response{body: response}} ->
        retval =
          response
          |> Jason.decode!()

        {:error, retval["message"]}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  @spec destroy_server(String.t()) :: {:ok, Models.Server.t()} | {:error, String.t()}
  def destroy_server(server_name) when is_binary(server_name) do
    {:ok, servers} = list_servers()
    server = Enum.find(servers, fn s -> s.name == server_name end)

    retval = BaseAPI.delete(@droplets_url <> "#{server.host_id}", request_headers())

    case retval do
      {:ok, %HTTPoison.Response{}} ->
        Logger.info("Destroyed server #{server_name}")
        {:ok, server}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  @spec destroy_server(Models.Server.t()) :: {:ok, Models.Server.t()} | {:error, String.t()}
  def destroy_server(%Models.Server{} = server) do
    retval = BaseAPI.delete(@droplets_url <> "#{inspect(server.id)}", request_headers())

    case retval do
      {:ok, %HTTPoison.Response{}} -> {:ok, server}
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
    end
  end

  @spec server_alive?(Models.Server.t()) :: boolean
  def server_alive?(%Models.Server{id: server_id}) do
    retval = BaseAPI.get(@droplets_url <> "#{server_id}", request_headers())

    case retval do
      {:ok, %HTTPoison.Response{}} -> true
      {:error, %HTTPoison.Error{}} -> false
    end
  end

  @spec auth_token() :: String.t()
  defp request_headers,
    do: [Authorization: "Bearer #{auth_token()}", "Content-Type": "application/json"]

  @spec request_headers() :: String.t()
  defp auth_token, do: Application.get_env(:digital_ocean, :auth_token)

  @spec from_droplet([%{required(String.t()) => any()}] | %{required(String.t()) => any()}) ::
          [Models.Server.t()] | Models.Server.t()
  defp from_droplet(droplets) when is_list(droplets) do
    Enum.map(droplets, &from_droplet/1)
  end

  defp from_droplet(droplet) do
    droplet =
      if Map.has_key?(droplet, "droplet") do
        droplet["droplet"]
      else
        droplet
      end

    ip =
      if droplet["networks"] do
        if droplet["networks"]["v4"] && Enum.count(droplet["networks"]["v4"]) > 0 do
          List.first(droplet["networks"]["v4"])["ip_address"]
        end
      end

    do_from_droplet(ip, droplet)
  end

  @spec do_from_droplet(ip :: String.t(), droplet :: %{required(String.t()) => any()}) ::
          Models.Server.t() | {:error, :decode_server_failed}
  defp do_from_droplet(ip, %{
         "id" => id,
         "name" => name,
         "size" => %{"memory" => memory, "vcpus" => vcpus, "disk" => disk},
         "status" => status,
         "image" => %{"slug" => image_slug},
         "region" => %{"slug" => region_slug}
       }) do
    %Models.Server{
      id: id,
      name: name,
      memory: memory,
      vcpus: vcpus,
      disk: disk,
      status: status,
      image: image_slug,
      region: region_slug,
      ip: ip,
      # TODO(ian): This might be incorrect
      state: :started,
      host: :digital_ocean
    }
  end

  defp do_from_droplet(_ip, _droplet) do
    {:error, :decode_server_failed}
  end
end
