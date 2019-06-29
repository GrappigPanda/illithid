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
end
