defmodule Illithid.Models.Server do
  @moduledoc """
  Represents a controlled server.
  """

  @required_keys [
    :id,
    :ip,
    :name,
    :region,
    :memory,
    :vcpus,
    :disk,
    :host,
    :status,
    :state,
    :image
  ]

  @enforce_keys @required_keys
  defstruct @required_keys

  @type t :: %__MODULE__{
          id: String.t(),
          ip: String.t(),
          name: String.t(),
          region: String.t(),
          memory: String.t(),
          vcpus: String.t(),
          disk: String.t(),
          host: atom(),
          status: String.t(),
          state: atom(),
          image: String.t()
        }

  @spec new(
          id :: String.t(),
          ip :: String.t(),
          name :: String.t(),
          region :: String.t(),
          memory :: String.t(),
          vcpus :: String.t(),
          disk :: String.t(),
          host :: atom(),
          status :: String.t(),
          state :: atom(),
          image :: String.t()
        ) :: t()
  # credo:disable-for-next-line
  def new(id, ip, name, region, memory, vcpus, disk, host, status, state, image) do
    %__MODULE__{
      id: id,
      ip: ip,
      name: name,
      region: region,
      memory: memory,
      vcpus: vcpus,
      disk: disk,
      host: host,
      status: status,
      state: state,
      image: image
    }
  end
end
