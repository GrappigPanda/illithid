defmodule Illithid.ServerManager.Hetzner.Regions do
  @moduledoc false
  @behaviour Illithid.ServerManager.RegionBehaviour

  alias Illithid.Models.Region

  #####################
  # Regions Callbacks #
  #####################

  def all_regions do
    # TODO(ian): Replace this with an API call.
    [
      Region.new("FSN", "fsn1", true)
    ]
  end

  def all_available_regions,
    do: all_regions() |> Enum.filter(fn %Region{available: available} -> available end)

  def unavailable_regions,
    do: all_regions() |> Enum.filter(fn %Region{available: available} -> !available end)
end
