defmodule Illithid.Timers.ServerlessWorkersTest do
  use ExUnit.Case, async: false

  alias Illithid.Constants.Hosts
  alias Illithid.Timers.ServerlessWorkers
  alias Illithid.Models.ServerCreationContext
  alias Illithid.ServerManager.DigitalOcean.Supervisor, as: DOSupervisor

  @digital_ocean_api Application.get_env(:illithid, :digital_ocean)[:api_module]

  setup_all do
    scc =
      ServerCreationContext.new(
        Hosts.digital_ocean(),
        "orphaned_server",
        "base-docker-image"
      )

    {:ok, serverless_pid} = start_supervised({ServerlessWorkers, [@digital_ocean_api]})

    {:ok, _} = start_supervised({DOSupervisor, [@digital_ocean_api]})

    {:ok, pid} = DOSupervisor.create_server(scc)

    %{pid: pid, serverless_pid: serverless_pid}
  end

  describe "Kills orphaned servers" do
    test "Correctly kills orphaned servers", %{pid: pid, serverless_pid: s_pid} do
      assert Process.alive?(pid)

      Process.send(s_pid, :kill_orphans, [])
      :timer.sleep(1_000)

      refute Process.alive?(pid)
    end
  end
end
