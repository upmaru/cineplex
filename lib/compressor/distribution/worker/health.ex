defmodule Compressor.Distribution.Worker.Health do
  @moduledoc """
  Checks health of workers
  """
  use GenServer

  alias Compressor.Distribution

  require Logger

  @spec start_link(any()) :: :ignore | {:ok, any()} | {:error, any()}
  def start_link(_) do
    case GenServer.start_link(__MODULE__, nil, name: {:global, __MODULE__}) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        Process.link(pid)
        {:ok, pid}
    end
  end

  @impl true
  @spec init(any()) :: {:ok, nil}
  def init(_) do
    Logger.info("[Compressor.Distribution.Worker.Health] Started...")
    schedule_health_check()
    {:ok, nil}
  end

  @impl true
  def handle_info(:check, state) do
    health_check()
    schedule_health_check()
    {:noreply, state}
  end

  defp health_check() do
    workers = Distribution.get_workers(state: "ready")

    Compressor.TaskSupervisor
    |> Task.Supervisor.async_stream(workers, Distribution.Worker.Check, :perform, [])
    |> Stream.run()
  end

  defp schedule_health_check() do
    Process.send_after(self(), :check, :timer.seconds(5))
  end
end
