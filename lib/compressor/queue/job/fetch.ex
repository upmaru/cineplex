defmodule Compressor.Queue.Job.Fetch do
  alias Compressor.Queue

  @spec perform() :: {:error, Ecto.Changeset.t()} | {:ok, any()}
  def perform() do
    module = Compressor.Adapter.job(:upmaru_studio)

    case module.fetch() do
      {:ok, {metadata, source}} -> store(metadata, source)
      {:error, :invalid_job} -> {:error, :invalid_job}
    end
  end

  defp store(metadata, source), do: Queue.enqueue(metadata, source)
end
