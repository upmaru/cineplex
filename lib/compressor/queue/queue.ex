defmodule Compressor.Queue do
  alias Compressor.Queue.{
    Job,
    Source
  }

  alias Job.Entry

  alias Compressor.Repo

  @spec create_job(Source.t(), map()) :: {:error, Ecto.Changeset.t()} | {:ok, Job.t()}
  def create_job(source, metadata) do
    %Job{source: source}
    |> Job.changeset(%{metadata: metadata})
    |> Repo.insert()
  end

  @spec update_job(Job.t(), map()) :: {:error, Ecto.Changeset.t()} | {:ok, Job.t()}
  def update_job(job, parameters) do
    job
    |> Job.changeset(parameters)
    |> Repo.update()
  end

  @spec create_job_entry(Job.t(), binary(), map()) ::
          {:error, Ecto.Changeset.t()} | {:ok, Entry.t()}
  def create_job_entry(job, name, parameters) do
    %Entry{job: job}
    |> Entry.changeset(%{name: name, parameters: parameters})
    |> Repo.insert()
  end
end
