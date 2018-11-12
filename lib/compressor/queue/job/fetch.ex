defmodule Compressor.Queue.Job.Fetch do
  alias Compressor.Queue
  alias Compressor.Queue.Job

  alias Job.Extract

  @spec perform() :: {:error, Ecto.Changeset.t() | atom} | {:ok, Job.t()}
  def perform() do
    module = Compressor.Adapter.job(:upmaru_studio)

    with {:ok, {metadata, source}} <- module.fetch(),
         {:ok, job} <- Queue.enqueue(metadata, source) do
      Extract.perform(job)
      {:ok, job}
    else
      {:error, reason} -> {:error, reason}
    end
  end
end
