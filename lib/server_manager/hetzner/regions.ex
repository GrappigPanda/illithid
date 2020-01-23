defmodule Illithid.ServerManager.Hetzner.Regions do
  @moduledoc false
  @behaviour Illithid.ServerManager.RegionBehaviour

  alias Illithid.Models.Region
  alias Illithid.Constants.Hosts

  #####################
  # Regions Callbacks #
  #####################

  @api Application.get_env(:illithid, Hosts.hetzner())[:api_module]

  def all_regions do
    case @api.list_locations() do
      {:ok, regions} when is_list(regions) -> regions
      error -> error
    end
  end

  def all_available_regions,
    do: all_regions() |> Enum.filter(fn %Region{available: available} -> available end)

  def unavailable_regions,
    do: all_regions() |> Enum.filter(fn %Region{available: available} -> !available end)
end
