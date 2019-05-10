defmodule Illithid.Docker do
  @moduledoc false
  alias Illithid.Docker.Models.{Container, Image}
  alias Illithid.Utils.BaseAPI

  require Logger

  @doc """
  Handles listing all images found on the remote server
  """
  @spec list_images(String.t(), boolean, number, boolean) :: [Image.t()]
  def list_images(server_ip, all \\ 0, limit \\ 25, size \\ false) do
    case BaseAPI.get(
           server_url(server_ip) <> "/images/json?all=#{all}&limit=#{limit}&size=#{size}"
         ) do
      {:ok, %HTTPoison.Response{body: body}} ->
        images =
          body
          |> Jason.decode!()
          |> Enum.map(&Image.from_map/1)

        {:ok, images}

      {:error, %HTTPoison.Error{reason: _reason} = error} ->
        Logger.debug("Got error #{inspect(error)} from #{__MODULE__} @ #{inspect(__ENV__)}")
        {:error, error}
    end
  end

  @doc """
  Finds a container's ID by its name
  """
  @spec find_container_by_name(String.t(), String.t()) :: Container.t() | []
  def find_container_by_name(server_ip, container_name) do
    correct_container_name =
      unless String.starts_with?(container_name, "/") do
        "/" <> container_name
      end

    server_ip
    |> list_containers()
    |> case do
      {:ok, containers} -> containers
      _ -> []
    end
    |> Enum.filter(fn container -> container.names == [correct_container_name] end)
    |> case do
      [%Container{} = container] -> container
      [] -> nil
    end
  end

  @doc """
  Handles pulling the image locally
  """
  @spec pull_image(String.t(), String.t()) :: Image.t()
  def pull_image(server_ip, image_name \\ "loicmahieu/wait-for-it") do
    # TODO(ian): Worth determining if there's a better image to be made
    request_data = %{
      fromImage: image_name,
      fromSrc: "https://hub.docker.com/r",
      repo: "wait-for-it",
      tag: "latest"
    }

    case BaseAPI.post(server_url(server_ip) <> "/images/create", Jason.encode!(request_data), [
           {"Content-Type", "application/json"}
         ]) do
      {:ok, %HTTPoison.Response{body: body}} ->
        containers =
          body
          |> Jason.decode!()

        {:ok, containers}

      {:error, %HTTPoison.Error{} = error} ->
        Logger.debug("Got error #{inspect(error)} from #{__MODULE__} @ #{inspect(__ENV__)}")
        {:error, error}
    end
  end

  # TODO(ian): Ensure limit is being used or remove it from here.
  @doc """
  Handles listing all containers found on the remote server
  """
  @spec list_containers(String.t(), boolean, number, boolean) ::
          {:ok, [Container.t()]} | {:error, HTTPoison.Error.t()}
  def list_containers(server_ip, all \\ 1, _limit \\ 25, size \\ false) do
    case BaseAPI.get(server_url(server_ip) <> "/containers/json?all=#{all}&size=#{size}") do
      {:ok, %HTTPoison.Response{body: body}} ->
        containers =
          body
          |> Jason.decode!()
          |> Enum.map(&Container.from_map/1)

        {:ok, containers}

      {:error, %HTTPoison.Error{} = error} ->
        Logger.debug("Got error #{inspect(error)} from #{__MODULE__} @ #{inspect(__ENV__)}")
        {:error, error}
    end
  end

  @doc """
  Creates a container to run
  """
  @spec create_container(String.t(), String.t(), String.t()) :: :ok | :error
  def create_container(server_ip, image_name, container_name) do
    create_request = %{
      image: image_name,
      Tty: true,
      OpenStdin: true,
      AttachStdin: false,
      AttachStdout: true,
      AttachStderr: false
    }

    case BaseAPI.post(
           server_url(server_ip) <> "/containers/create?name=#{container_name}",
           Jason.encode!(create_request),
           [{"Content-Type", "application/json"}]
         ) do
      {:ok, %HTTPoison.Response{status_code: 201}} ->
        :ok

      {:ok, %HTTPoison.Response{body: body, status_code: status_code}} ->
        Logger.debug(
          "Got error #{inspect(body)} with status code #{inspect(status_code)} from #{__MODULE__} @ #{
            inspect(__ENV__)
          }"
        )

        :error

      {:error, %HTTPoison.Error{reason: _reason} = error} ->
        Logger.debug("Got error #{inspect(error)} from #{__MODULE__} @ #{inspect(__ENV__)}")
        :error
    end
  end

  @doc """
  Starts a container in the local server.
  """
  @spec start_container(String.t(), String.t()) :: {:ok, Container.t()}
  def start_container(server_ip, container_id) do
    case BaseAPI.post(server_url(server_ip) <> "/containers/#{container_id}/start", "") do
      {:ok, %HTTPoison.Response{status_code: 204}} ->
        :ok

      {:ok, %HTTPoison.Response{body: body, status_code: status_code}} ->
        Logger.debug(
          "Got error #{inspect(body)} with status code #{inspect(status_code)} from #{__MODULE__} @ #{
            inspect(__ENV__)
          }"
        )

        :error

      {:error, %HTTPoison.Error{reason: _reason} = error} ->
        Logger.debug("Got error #{inspect(error)} from #{__MODULE__} @ #{inspect(__ENV__)}")
        :error
    end
  end

  @doc """
  Stops the container in the local server.
  """
  @spec stop_container(String.t(), String.t()) :: {:ok, Container.t()}
  def stop_container(server_ip, container_id) do
    case BaseAPI.post(server_url(server_ip) <> "/containers/#{container_id}/stop", "") do
      {:ok, %HTTPoison.Response{status_code: 204}} ->
        :ok

      {:ok, %HTTPoison.Response{body: body, status_code: status_code}} ->
        Logger.debug(
          "Got error #{inspect(body)} with status code #{inspect(status_code)} from #{__MODULE__} @ #{
            inspect(__ENV__)
          }"
        )

        :error

      {:error, %HTTPoison.Error{reason: _reason} = error} ->
        Logger.debug("Got error #{inspect(error)} from #{__MODULE__} @ #{inspect(__ENV__)}")
        :error
    end
  end

  @doc """
  Retrieves logs from a container
  """
  @spec retrieve_container_logs(String.t(), String.t()) :: [String.t()]
  def retrieve_container_logs(
        server_ip,
        container_id,
        timestamps \\ false,
        stdout \\ true,
        stderr \\ false
      ) do
    case BaseAPI.get(
           server_url(server_ip) <>
             "/containers/#{container_id}/logs?timestamps=#{timestamps}&stdout=#{stdout}&stderr=#{
               stderr
             }"
         ) do
      {:ok, %HTTPoison.Response{body: body}} ->
        Logger.debug(body)
        :ok

      {:error, %HTTPoison.Error{reason: _reason} = error} ->
        Logger.debug("Got error #{inspect(error)} from #{__MODULE__} @ #{inspect(__ENV__)}")
        :error
    end
  end

  @doc """
  Executes commands inside a running container
  """
  @spec exec_command(String.t(), String.t(), [String.t()], list) ::
          {:ok, number, String.t()} | {:error, number, String.t()}
  def exec_command(server_ip, container_id, commands, env_args \\ []) when is_list(commands) do
    request_data = %{
      AttachStdin: false,
      AttachStdout: true,
      AttachStderr: false,
      Cmd: commands,
      Env: env_args,
      Tty: true
    }

    case BaseAPI.post(
           server_url(server_ip) <> "/containers/#{container_id}/exec",
           Jason.encode!(request_data),
           [{"Content-Type", "application/json"}]
         ) do
      {:ok, %HTTPoison.Response{body: body}} ->
        response =
          body
          |> Jason.decode!()

        inter_request = %{
          Detach: false,
          Tty: false
        }

        case BaseAPI.post(
               server_url(server_ip) <> "/exec/#{response["Id"]}/start",
               Jason.encode!(inter_request),
               [{"Content-Type", "application/json"}]
             ) do
          {:ok, %HTTPoison.Response{body: body}} ->
            output = parse_exec_output(body)

            {:ok, output}

          {:error, %HTTPoison.Error{reason: _reason} = error} ->
            Logger.debug("Got error #{inspect(error)} from #{__MODULE__} @ #{inspect(__ENV__)}")
            :error
        end

      {:error, %HTTPoison.Error{reason: _reason} = error} ->
        Logger.debug("Got error #{inspect(error)} from #{__MODULE__} @ #{inspect(__ENV__)}")
        :error
    end
  end

  @spec server_url(String.t(), String.t(), String.t()) :: String.t()
  defp server_url(server_ip, scheme \\ "http", port \\ "2375") do
    "#{scheme}://#{server_ip}:#{port}"
  end

  @spec parse_exec_output(exec_output :: String.t()) :: String.t()
  defp parse_exec_output(exec_output) when is_binary(exec_output) do
    exec_output
    |> String.codepoints()
    |> Enum.filter(fn x -> String.printable?(x) end)
    |> Enum.join()
  end
end
