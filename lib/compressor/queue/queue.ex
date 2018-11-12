defmodule Compressor.Queue do
  alias Compressor.Queue.Job
  alias Job.Entry

  alias Compressor.Repo

  @spec enqueue(map, binary) :: {:error, Ecto.Changeset.t()} | {:ok, Job.t()}
  def enqueue(metadata, source) do
    changeset = Job.changeset(%Job{}, %{metadata: metadata, source: source})

    case Repo.insert(changeset) do
      {:ok, job} -> {:ok, job}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def add_entry(Job.Entry()) do

  end
end
