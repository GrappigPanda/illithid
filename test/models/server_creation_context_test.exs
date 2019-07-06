defmodule Illithid.ServerManager.Models.ServerCreationContextTest do
  use ExUnit.Case, async: true

  alias Illithid.Constants.Hosts
  alias Illithid.Models.ServerCreationContext

  describe "new/2" do
    test "Correct data, creates" do
      scc = ServerCreationContext.new(Hosts.digital_ocean(), "Foobar", "base-docker-image")

      assert scc.host == Hosts.digital_ocean()
      assert scc.server_id == "Foobar"
      assert scc.image == "base-docker-image"
    end
  end
end
