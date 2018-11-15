defmodule Compressor.Encode.Worker.Health do
  @moduledoc """
  Checks health of workers
  """

  use GenServer

  require Logger

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
  def init(_) do
    Logger.info("[Compressor.Queue.Worker.Health] Started...")
    schedule_health_check()
    {:ok, nil}
  end

  @impl true
  def handle_info(:check, state) do
    # run health check
    schedule_health_check()
    {:noreply, state}
  end

  defp schedule_health_check() do
    Process.send_after(self(), :check, :timer.seconds(5))
  end
end
