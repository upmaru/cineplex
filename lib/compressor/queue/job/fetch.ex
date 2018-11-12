defmodule Compressor.Queue.Job.Fetch do
  alias Compressor.Queue
  alias Compressor.Queue.Job

  alias Job.Extract

  @spec perform(atom) :: {:error, Ecto.Changeset.t() | atom} | {:ok, Job.t()}
  def perform(adapter) do
    module = Compressor.Adapter.job(adapter)

    with {:ok, {metadata, source}} <- module.fetch(),
         {:ok, job} <- Queue.enqueue(metadata, source) do
      Extract.perform(job)
      {:ok, job}
    else
      {:error, reason} -> {:error, reason}
    end
  end
end
