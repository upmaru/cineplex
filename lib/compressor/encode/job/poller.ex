defmodule Compressor.Encode.Job.Poller do
  use GenServer

  require Logger

  @spec start_link(any()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(_) do
    case GenServer.start_link(__MODULE__, nil, name: {:global, __MODULE__}) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        Process.link(pid)
        {:ok, pid}

      :ignore ->
        :ignore
    end
  end

  @impl true
  @spec init(any()) :: {:ok, nil}
  def init(_) do
    if enabled() do
      Logger.info("[Compressor.Encode.Job.Poller] Started...")
      schedule_polling()
      {:ok, nil}
    else
      :ignore
    end
  end

  @impl true
  def handle_info(:perform, state) do
    # do something here to fetch jobs
    schedule_polling()
    {:noreply, state}
  end

  defp schedule_polling() do
    Process.send_after(self(), :perform, :timer.seconds(5))
  end

  defp enabled do
    Application.get_env(:compressor, :server)[:enabled]
  end
end
