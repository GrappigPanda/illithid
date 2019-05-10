defmodule Models.DigitalOcean.CreateRequest do
  @moduledoc false
  @required_keys [:name, :region, :size, :image]

  @type t :: %__MODULE__{
          name: String.t(),
          region: String.t(),
          size: String.t(),
          image: String.t()
        }

  @enforce_keys @required_keys
  defstruct @required_keys ++ [:ssh_keys]
end
