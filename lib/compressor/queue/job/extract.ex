defmodule Compressor.Queue.Job.Extract do
  alias Compressor.Queue.Job

  @spec perform(Job.t()) :: {:error, Ecto.Changeset.t()} | {:ok, Job.t()}
  def perform(job) do
    module = Compressor.Adapter.job(:upmaru_studio)

    with {:ok, entries} <- module.extract() do

    end
  end
end
