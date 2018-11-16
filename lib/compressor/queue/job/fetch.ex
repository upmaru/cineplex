defmodule Compressor.Queue.Job.Fetch do
  alias Compressor.Queue

  alias Queue.{
    Job,
    Source
  }

  alias Job.Extract

  @spec perform(Source.t()) ::
          {:error, Ecto.Changeset.t() | atom} | {:ok, %{job: Job.t(), entries: [Job.Entry.t()]}}
  def perform(%Source{endpoint: endpoint, token: token} = source) do
    pipeline = Compressor.Pipeline.from_source(source)
    client = pipeline.client(endpoint, token)

    with {:ok, params} <- pipeline.job(client),
         {:ok, job} <- Queue.create_job(source, params) do
      Extract.perform(job)
    else
      {:error, reason} -> {:error, reason}
    end
  end
end
