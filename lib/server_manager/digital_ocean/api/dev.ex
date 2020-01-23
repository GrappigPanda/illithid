defmodule Illithid.ServerManager.DigitalOcean.API.Dev do
  @behaviour Illithid.ServerManager.HostAPIBehaviour
  @moduledoc """
  The production API handler
  """

  alias Jason
  alias Illithid.Constants.Hosts
  alias Illithid.Models

  require Logger

  @spec list_locations() :: {:ok, [Models.Region.t()]}
  def list_locations do
    {:ok,
     [
       %Illithid.Models.Region{available: true, name: "New York 1", slug: "nyc1"},
       %Illithid.Models.Region{available: true, name: "Singapore 1", slug: "sgp1"},
       %Illithid.Models.Region{available: true, name: "London 1", slug: "lon1"},
       %Illithid.Models.Region{available: true, name: "New York 3", slug: "nyc3"},
       %Illithid.Models.Region{available: true, name: "Amsterdam 3", slug: "ams3"},
       %Illithid.Models.Region{available: true, name: "Frankfurt 1", slug: "fra1"},
       %Illithid.Models.Region{available: true, name: "Toronto 1", slug: "tor1"},
       %Illithid.Models.Region{
         available: true,
         name: "San Francisco 2",
         slug: "sfo2"
       },
       %Illithid.Models.Region{available: true, name: "Bangalore 1", slug: "blr1"}
     ]}
  end

  @spec list_images(local_only :: bool()) :: {:ok, map()}
  def list_images(_local_only \\ true) do
    {:ok,
     %{
       "images" => [
         %{
           "created_at" => "2018-06-17T01:06:35Z",
           "description" => nil,
           "distribution" => "Ubuntu",
           "error_message" => "",
           "id" => 35_362_300,
           "min_disk_size" => 25,
           "name" => "docker-daemon-001",
           "public" => false,
           "regions" => ["nyc1"],
           "size_gigabytes" => 2.07,
           "slug" => nil,
           "status" => "available",
           "tags" => [],
           "type" => "snapshot"
         },
         %{
           "created_at" => "2018-06-21T00:33:44Z",
           "description" => nil,
           "distribution" => "Ubuntu",
           "error_message" => "",
           "id" => 35_483_384,
           "min_disk_size" => 25,
           "name" => "docker-daemon-002",
           "public" => false,
           "regions" => ["nyc1"],
           "size_gigabytes" => 2.75,
           "slug" => nil,
           "status" => "available",
           "tags" => [],
           "type" => "snapshot"
         },
         %{
           "created_at" => "2018-07-01T03:18:22Z",
           "description" => nil,
           "distribution" => "Ubuntu",
           "error_message" => "",
           "id" => 35_799_624,
           "min_disk_size" => 25,
           "name" => "base-docker-image",
           "public" => false,
           "regions" => ["nyc1", "nyc3"],
           "size_gigabytes" => 2.94,
           "slug" => nil,
           "status" => "available",
           "tags" => [],
           "type" => "snapshot"
         }
       ],
       "links" => %{},
       "meta" => %{"total" => 3}
     }}
  end

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
  def list_servers(ops \\ [fail: false]) do
    case Access.get(ops, :fail) do
      true ->
        {:error, "asdf"}

      _ ->
        {:ok, [mock_server(), mock_server()]}
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
    Models.Server.new(
      "0",
      "127.0.0.1",
      server_name,
      "NYC",
      "4gb",
      "4",
      "100gb",
      Hosts.digital_ocean(),
      "started",
      :started,
      "test/001"
    )
  end
end
