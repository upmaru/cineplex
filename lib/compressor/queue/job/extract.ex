defmodule Compressor.Queue.Job.Extract do
  alias Compressor.Queue.Job

  @spec perform(atom, Job.t()) :: {:error, Ecto.Changeset.t()} | {:ok, Job.t()}
  def perform(adapter, job) do
    module = Compressor.Adapter.job(adapter)

    with {:ok, entries} <- module.extract(job) do

    else

    end
  end
end
