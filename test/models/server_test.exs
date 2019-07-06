defmodule Illithid.ServerManager.Models.ServerTest do
  alias Illithid.Models.Server

  use ExUnit.Case, async: true

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
          :digital_ocean,
          "running",
          :running,
          "ianleeclark/base-image-001"
        )

      assert server
    end
  end
end
