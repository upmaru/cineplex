defmodule Compressor.Distribution.Worker.Scheduler do
  use GenServer

  alias Compressor.{
    Distribution, Queue
  }

  alias Distribution.Worker

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
    Logger.info("[Compressor.Distribution.Worker.Scheduler] Started...")
    run_next_cycle()
    {:ok, nil}
  end

  @impl true
  def handle_info(:perform, state) do
    schedule_work()
    run_next_cycle()
    {:noreply, state}
  end

  defp schedule_work do
    workers = Distribution.get_workers(state: "ready")
    job_entries = Queue.get_job_entries(:waiting)
    matchings = Enum.zip(workers, job_entries)

    Compressor.TaskSupervisor
    |> Task.Supervisor.async_stream(matchings, Worker.Distribute, :perform, [])
    |> Stream.run()
  end

  defp run_next_cycle() do
    Process.send_after(self(), :perform, :timer.seconds(5))
  end
end
