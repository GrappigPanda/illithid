defmodule Illithid.ServerManager.Models.ServerTest do
  use ExUnit.Case, async: true

  alias Illithid.Constants.Hosts
  alias Illithid.Models.Server

  describe "new/11" do
    test "Completes, correct data" do
      server =
        Server.new(
          "ID",
          "127.0.0.1",
          "TestServer-001",
          "us-east-01",
          "4gb",
          "2",
          "120gb",
          Hosts.digital_ocean(),
          "running",
          :running,
          "ianleeclark/base-image-001"
        )

      assert server
    end
  end
end
