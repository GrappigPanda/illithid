defmodule Illithid.ServerManager.Models.ServerCreationContext do
  @moduledoc """
  Dictates how servers should be built
  """

  @required_keys [
    :host,
    :server_id,
    :image
  ]

  @enforce_keys @required_keys
  defstruct @required_keys

  @type t :: %__MODULE__{
          host: :digital_ocean,
          server_id: String.t(),
          image: number()
        }

  @spec new(host :: atom(), server_id :: String.t(), image :: number()) :: t()
  def new(host, server_id, image)
      when is_atom(host) and is_bitstring(server_id) and is_number(image) do
    %__MODULE__{
      host: host,
      server_id: server_id,
      # TODO(ian): Use this and the new list_images to grab the id
      image: image
    }
  end
end
