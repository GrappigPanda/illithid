defmodule Illithid.ServerManager.RegionBehaviour do
  @moduledoc false

  @callback all_regions() :: [Region.t()]
  @callback all_available_regions() :: [Region.t()]
  @callback unavailable_regions() :: [Region.t()]
end
