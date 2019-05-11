defmodule Illithid.ServerManager.WorkerBehaviour do
  @moduledoc """
  This models the contract that a worker for a host must comply with.
  """

  #####################
  # Server Management #
  #####################
  @callback server_alive?(pid()) :: boolean | {:error, atom()}

  ########################
  # Container Management #
  ########################
  #
  # Things we may want
  #   1. container_running?
  #   2. setup_server
  #     - download_docker_image
  #     - start_container
  #     - stop_container
  #   3. clone_repo

  #####################
  # Backend API Stuff #
  #####################
  #
  # Things we may want.
  #   1. push_build_update
  #     - This may need to be different functions?
end
