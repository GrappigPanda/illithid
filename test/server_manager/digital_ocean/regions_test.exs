defmodule Illithid.ServerManager.DigitalOcean.RegionsTest do
  use ExUnit.Case, async: true

  alias Illithid.ServerManager.DigitalOcean.Regions
  alias Illithid.Models.Region

  describe "all_available_regions/0" do
    test "Lists all regions" do
      regions = Regions.all_available_regions()

      assert Enum.count(regions) > 0
    end

    test "Lists only available regions" do
      assert Regions.all_available_regions()
             |> Enum.map(fn %Region{available: available} -> available end)
             |> Enum.all?()
    end
  end

  describe "all_unavailable_regions/0" do
    test "No regions are available" do
      refute Regions.all_available_regions()
             |> Enum.map(fn %Region{available: available} -> available end)
             |> Enum.all?()
             |> Kernel.not()
    end
  end
end
