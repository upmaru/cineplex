defmodule Compressor.Queue do
  alias Compressor.Queue.Job
  alias Job.Entry

  alias Compressor.Repo

  @spec enqueue(map, binary) :: {:error, Ecto.Changeset.t()} | {:ok, Job.t()}
  def enqueue(metadata, source) do
    %Job{}
    |> Job.changeset(%{metadata: metadata, source: source})
    |> Repo.insert()
  end

  @spec enqueue(Job.t(), binary(), map()) :: {:error, Ecto.Changeset.t()} | {:ok, Entry.t()}
  def enqueue(job, name, parameters) do
    %Entry{job: job}
    |> Entry.changeset(%{name: name, parameters: parameters})
    |> Repo.insert()
  end
end
