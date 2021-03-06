defmodule Illithid.Models.ServerCreationContext do
  @moduledoc """
  Dictates how servers should be built
  """

  @required_keys [
    :host,
    :server_id,
    :image,
    :region
  ]

  @enforce_keys @required_keys
  defstruct @required_keys

  @type t :: %__MODULE__{
          host: atom(),
          server_id: String.t(),
          region: String.t(),
          image: String.t()
        }

  @spec new(host :: atom(), server_id :: String.t(), region :: String.t(), image :: String.t()) ::
          t()
  def new(host, server_id, region, image)
      when is_atom(host) and is_bitstring(server_id) and is_binary(region) and is_bitstring(image) do
    %__MODULE__{
      host: host,
      server_id: server_id,
      region: region,
      image: image
    }
  end
end
