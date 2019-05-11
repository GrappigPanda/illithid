defmodule Illithid.ServerManager.Models.Server do
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
          host: :digital_ocean,
          status: String.t(),
          state: atom(),
          image: String.t()
        }

  # TODO(ian): Change to `new()`
  @doc false
  def changeset(server, attrs) do
    cast(server, attrs, @required_keys)
  end

  defp cast(%__MODULE__{} = server, attributes, keys) do
    Enum.map(keys, fn key ->
      Map.put(server, key, Map.get(attributes, key))
    end)
  end
end
