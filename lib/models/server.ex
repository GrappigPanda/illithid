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

  # TODO(ian): Change to `new()`
  @doc false
  def changeset(build_server, attrs) do
    build_server
    |> cast(attrs, @required_keys)
  end

  defp cast(%__MODULE__{} = server, attributes, keys) do
    Enum.map(keys, fn key ->
      Map.put(server, key, Map.get(attributes, key))
    end)
  end
end
