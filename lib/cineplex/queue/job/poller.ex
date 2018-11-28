defmodule Cineplex.Queue.Job.Poller do
  use GenServer

  alias Cineplex.{
    Repo,
    Queue
  }

  require Logger

  @spec start_link(any()) :: :ignore | {:error, any()} | {:ok, pid()}
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
    Logger.info("[Cineplex.Queue.Job.Poller] Started...")
    schedule_polling()
    {:ok, nil}
  end

  @impl true
  def handle_info(:perform, state) do
    fetch_jobs()
    schedule_polling()
    {:noreply, state}
  end

  defp fetch_jobs do
    sources = Repo.all(Queue.Source)

    Cineplex.TaskSupervisor
    |> Task.Supervisor.async_stream(sources, Queue.Job.Fetch, :perform, [])
    |> Stream.run()
  end

  defp schedule_polling() do
    Process.send_after(self(), :perform, :timer.seconds(5))
  end
end
