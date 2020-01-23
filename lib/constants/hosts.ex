defmodule Illithid.Constants.Hosts do
  @moduledoc false

  alias Illithid.ServerManager.DigitalOcean.Supervisor, as: DOSupervisor
  alias Illithid.ServerManager.Hetzner.Supervisor, as: HetznerSupervisor

  #########
  # Types #
  #########

  @digital_ocean :digital_ocean
  @hetzner :hetzner
  @all_hosts [@digital_ocean, @hetzner]

  @type t :: [atom()]

  ########
  # APIs #
  ########
  @digital_ocean_api Application.get_env(:illithid, @digital_ocean)[:api_module]
  @hetzner_api Application.get_env(:illithid, @hetzner)[:api_module]

  ####################
  # Public Functions #
  ####################

  @spec all_hosts() :: t()
  def all_hosts, do: @all_hosts

  @spec digital_ocean() :: :digital_ocean
  def digital_ocean, do: @digital_ocean

  @spec hetzner() :: :hetzner
  def hetzner, do: @hetzner

  @spec api_for_host(host :: atom()) :: module()
  def api_for_host(@hetzner) do
    @hetzner_api
  end

  def api_for_host(@digital_ocean) do
    @digital_ocean_api
  end

  @spec resolve_supervisor_from_host(host :: atom()) :: {:ok, module()}
  def resolve_supervisor_from_host(host) when is_atom(host) do
    case host do
      @digital_ocean -> {:ok, DOSupervisor}
      @hetzner -> {:ok, HetznerSupervisor}
    end
  end
end
