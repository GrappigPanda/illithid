defmodule Illithid.Constants.Hosts do
  # TODO(ian): Write this in
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

  ####################
  # Public Functions #
  ####################

  @spec all_hosts() :: t()
  def all_hosts, do: @all_hosts

  @spec digital_ocean() :: :digital_ocean
  def digital_ocean, do: @digital_ocean

  @spec hetzner() :: :hetzner
  def hetzner, do: @hetzner

  @spec resolve_supervisor_from_host(host :: atom()) :: {:ok, module()}
  def resolve_supervisor_from_host(host) when is_atom(host) do
    case host do
      @digital_ocean -> {:ok, DOSupervisor}
      @hetzner -> {:ok, HetznerSupervisor}
    end
  end
end
