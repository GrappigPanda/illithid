defmodule Illithid.ServerManager.Models.ServerCreationContext do
  @moduledoc """
  Dictates how servers should be built
  """

  @required_keys [
    :host,
    :server_id
  ]

  @enforce_keys @required_keys
  defstruct @required_keys

  @type t :: %__MODULE__{
          host: :digital_ocean,
          server_id: String.t()
        }

  @spec new(host :: atom(), server_id :: String.t()) :: t()
  def new(host, server_id) when is_atom(host) and is_bitstring(server_id) do
    %__MODULE__{
      host: host,
      server_id: server_id
    }
  end
end
