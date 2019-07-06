defmodule Illithid.ServerManager.Models.RegionTest do
  use ExUnit.Case, async: true

  alias Illithid.ServerManager.Models.Region

  describe "new/3" do
    test "Completes, correct data is persisted" do
      retval = Region.new("name", "slug", false)

      assert retval.name == "name"
      assert retval.slug == "slug"
      assert retval.available == false

      retval2 = Region.new("name", "slug", true)

      assert retval2.available == true
    end
  end
end
