defmodule IllithidTest do
  use ExUnit.Case, async: true

  alias Illithid
  alias Illithid.Constants.Hosts
  alias Illithid.Models.ServerCreationContext
  alias Illithid.ServerManager.Hetzner.Supervisor

  setup_all do
    {:ok, _} = start_supervised(Supervisor)

    %{}
  end

  describe "create_server/1" do
    test "Invalid region selections" do
      scc = ServerCreationContext.new(Hosts.hetzner(), "asdf", "fra1", "foobar")
      assert Illithid.create_server(scc) == {:error, :invalid_region_for_host}
    end

    test "Valid region selections" do
      scc = ServerCreationContext.new(Hosts.hetzner(), "asdf", "fsn1", "foobar")
      assert Illithid.create_server(scc)
    end
  end
end
