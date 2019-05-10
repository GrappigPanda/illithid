defmodule Illithid.Docker.Models.Image do
  @moduledoc false
  @required_keys [:id, :name]

  @enforce_keys @required_keys
  defstruct @required_keys

  @type t :: %__MODULE__{id: String.t(), name: String.t()}

  @doc """
  Handles converting map -> Image
  """
  @spec from_map(%{required(String.t()) => any()}) :: t()
  def from_map(input) do
    %__MODULE__{
      id: input["Id"],
      name: List.first(input["RepoTags"])
    }
  end

  @doc """
  Handles converting Image -> map
  """
  @spec to_map(t()) :: %{required(atom()) => any()}
  def to_map(%__MODULE__{} = input) do
    %{
      name: input.names,
      id: input.id
    }
  end
end
