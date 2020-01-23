defmodule Illithid.ServerManager.RegionBehaviour do
  @moduledoc false

  alias Illithid.Models.Region

  @callback all_regions() :: [Region.t()] | {:error, any()}
  @callback all_available_regions() :: [Region.t()]
  @callback unavailable_regions() :: [Region.t()]
end
