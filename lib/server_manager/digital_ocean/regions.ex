defmodule Illithid.ServerManager.DigitalOcean.Regions do
  @moduledoc false
  @behaviour Illithid.ServerManager.RegionBehaviour

  #####################
  # Regions Callbacks #
  #####################

  def all_regions do
    # TODO(ian): Replace this with an API call.
    [
      "ny1",
      "ny2",
      "ny3",
      "sf1",
      "sf2",
      ""
    ]
  end

  def all_available_regions, do: all_regions()

  def unavailable_regions, do: []
end
