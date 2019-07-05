defmodule Illithid.ServerManager.Models.ServerCreationContextTest do
  alias Illithid.ServerManager.Models.ServerCreationContext

  use ExUnit.Case, async: true

  describe "new/2" do
    test "Correct data, creates" do
      scc = ServerCreationContext.new(:digital_ocean, "Foobar")

      assert scc.host == :digital_ocean
      assert scc.server_id == "Foobar"
    end
  end
end
