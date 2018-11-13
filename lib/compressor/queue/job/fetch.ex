defmodule Compressor.Queue.Job.Fetch do
  alias Compressor.Queue

  alias Queue.{
    Job,
    Source
  }

  alias Job.Extract

  @spec perform(Source.t()) :: {:error, Ecto.Changeset.t() | atom} | {:ok, Job.t()}
  def perform(source) do
    adapter = Compressor.Adapter.from_source(source)
    client = adapter.client(source.endpoint, source.token)

    with {:ok, metadata} <- adapter.job(client),
         {:ok, job} <- Queue.create_job(source, metadata)
    do
      Extract.perform(job)
    else
      {:error, reason} -> {:error, reason}
    end
  end
end
