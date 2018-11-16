defmodule Compressor.Distribution.Worker.Scheduler do
  use GenServer

  alias Compressor.Distribution
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
    distribute()
    run_next_cycle()
    {:noreply, state}
  end

  defp distribute do
    workers = Distribution.get_workers(state: "ready")

    # max concurrency 1 so jobs don't get distributed twice
    Compressor.TaskSupervisor
    |> Task.Supervisor.async_stream(workers, Worker.Distribute, :to, [], max_concurrency: 1)
    |> Stream.run()
  end

  defp run_next_cycle() do
    Process.send_after(self(), :perform, :timer.seconds(5))
  end
end
