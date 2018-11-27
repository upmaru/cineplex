defmodule Cineplex.Worker.Event do
  alias Cineplex.Queue.{
    Job, Source
  }

  require Logger

  @spec track(any(), Cineplex.Queue.Job.t(), any()) :: :error | :ok
  def track(%Job{source: %Source{endpoint: endpoint, token: token} = source} = job, name, metadata \\ %{}) do
    reel = Cineplex.Reel.from_source(source)
    client = reel.client(endpoint, token)

    case reel.track(client, job, %{"name" => name, "metadata" => metadata}) do
      {:ok, :tracked} ->
        Logger.info("[Cineplex.Worker.Event] #{name}", event: %{"#{name}" => metadata})
        :ok
      {:error, :tracking_failed} ->
        Logger.info("[Cineplex.Worker.Event] #{name} failed")
        :error
    end
  end
end
