defmodule Illithid.Models.Region do
  @moduledoc false
  @required_keys [:name, :slug, :available]

  @enforce_keys @required_keys
  defstruct @required_keys

  @type t :: %__MODULE__{name: String.t(), slug: String.t(), available: boolean()}

  @spec new(name :: String.t(), slug :: String.t(), available :: boolean()) :: t()
  def new(name, slug, available)
      when is_bitstring(name) and is_bitstring(slug) and is_boolean(available) do
    %__MODULE__{
      name: name,
      slug: slug,
      available: available
    }
  end
end
