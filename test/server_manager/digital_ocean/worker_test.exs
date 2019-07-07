defmodule Illithid.ServerManager.DigitalOcean.WorkerTest do
  use ExUnit.Case, async: false

  alias Illithid.Constants.Hosts
  alias Illithid.Models.{Server, ServerCreationContext}
  alias Illithid.ServerManager.DigitalOcean.Supervisor
  alias Illithid.ServerManager.Worker

  setup_all do
    server =
      Server.new(
        "0",
        "127.0.0.1",
        "test_name",
        "NYC",
        "4gb",
        "4",
        "100gb",
        Hosts.digital_ocean(),
        "started",
        :started,
        "test/001"
      )

    scc =
      ServerCreationContext.new(
        server.host,
        server.id,
        "base-docker-image"
      )

    {:ok, _} = start_supervised(Supervisor)

    {:ok, pid} = Supervisor.create_server(scc)
    {:ok, pid_delete} = Supervisor.create_server(Map.put(scc, :server_id, "delete-me"))

    %{server: server, pid: pid, pid_delete: pid_delete}
  end

  describe "server_alive?/1" do
    test "Pass, correct pid", %{pid: pid} do
      assert Worker.server_alive?(pid)
    end
  end

  describe "destroy_server/1" do
    test "Pass, correct pid", %{pid_delete: pid, server: server} do
      assert Worker.destroy_server(pid) == {:ok, server}
    end
  end

  describe "get_server_from_process/1" do
    test "Pass, correct pid", %{server: server, pid: pid} do
      worker_server = Worker.get_server_from_process(pid)

      assert worker_server == server
    end
  end

  describe "get_server_name/1" do
    test "Pass, correct pid", %{server: server, pid: pid} do
      server_name = Worker.get_server_name(pid)
      assert String.starts_with?(server_name, server.id)
    end
  end
end
