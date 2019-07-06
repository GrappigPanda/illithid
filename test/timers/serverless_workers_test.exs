defmodule Illithid.Timers.ServerlessWorkersTest do
  use ExUnit.Case, async: false

  alias Illithid.Constants.Hosts
  alias Illithid.Timers.ServerlessWorkers
  alias Illithid.Models.ServerCreationContext
  alias Illithid.ServerManager.DigitalOcean.Supervisor

  setup_all do
    scc =
      ServerCreationContext.new(
        Hosts.digital_ocean(),
        "orphaned_server",
        "base-docker-image"
      )

    {:ok, pid} = Supervisor.create_server(scc)

    %{pid: pid}
  end

  describe "Kills orphaned servers" do
    test "Correctly kills orphaned servers", %{pid: pid} do
      assert Process.alive?(pid)

      Process.send(Process.whereis(ServerlessWorkers), :kill_orphans, [])
      :timer.sleep(1_000)

      refute Process.alive?(pid)
    end
  end
end
