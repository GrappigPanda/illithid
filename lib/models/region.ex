defmodule Illithid.ServerManager.Models.Region do
  @moduledoc false
  @required_keys [:name, :slug, :available]

  @enforce_keys @required_keys
  defstruct @required_keys

  @type t :: %__MODULE__{name: String.t(), slug: String.t(), available: boolean()}
end
