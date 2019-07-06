defmodule Illithid.ServerManager.Models.ServerCreationContextTest do
  alias Illithid.Models.ServerCreationContext

  use ExUnit.Case, async: true

  describe "new/2" do
    test "Correct data, creates" do
      scc = ServerCreationContext.new(:digital_ocean, "Foobar", "base-docker-image")

      assert scc.host == :digital_ocean
      assert scc.server_id == "Foobar"
      assert scc.image == "base-docker-image"
    end
  end
end
