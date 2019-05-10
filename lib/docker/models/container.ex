defmodule Illithid.Docker.Models.Container do
  @moduledoc false
  @required_keys [:id, :image_id, :names, :state, :ip_address]

  @enforce_keys @required_keys
  defstruct @required_keys

  @type t :: %__MODULE__{
          id: String.t(),
          image_id: String.t(),
          names: [String.t()],
          state: String.t(),
          ip_address: String.t()
        }

  @doc """
  Handles converting map -> Container
  """
  @spec from_map(%{required(String.t()) => any()}) :: t()
  def from_map(input) do
    %__MODULE__{
      id: input["Id"],
      names: input["Names"],
      image_id: input["ImageID"],
      state: input["State"],
      ip_address: input["NetworkSettings"]["Networks"]["bridge"]["IPAddress"]
    }
  end

  @doc """
  Handles converting Container -> map
  """
  @spec to_map(t()) :: map
  def to_map(%__MODULE__{} = input) do
    %{
      id: input.id,
      names: input.names,
      image_id: input.image_id,
      state: input.state,
      ip_address: input.ip_address
    }
  end
end
