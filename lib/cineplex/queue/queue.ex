defmodule Cineplex.Queue do
  alias Cineplex.Queue.{
    Job,
    Source
  }

  alias Cineplex.Repo

  @spec get_job([{:resource, binary()}, ...]) :: Job.t() | nil
  def get_job(resource: resource) do
    Job
    |> Repo.get_by!(resource: resource)
    |> Repo.preload([:source])
  end

  @spec get_source([{:endpoint, any()}, ...]) :: Source.t() | nil
  def get_source(endpoint: endpoint) do
    Repo.get_by(Source, endpoint: endpoint)
  end

  @spec create_source(binary(), binary(), binary()) ::
          {:error, Ecto.Changeset.t()} | {:ok, Source.t()}
  def create_source(endpoint, token, reel) do
    %Source{}
    |> Source.changeset(%{endpoint: endpoint, token: token, reel: reel})
    |> Repo.insert(on_conflict: :nothing)
  end

  @spec update_source(Source.t(), map()) :: {:error, Ecto.Changeset.t()} | {:ok, Source.t()}
  def update_source(source, parameters) do
    source
    |> Source.changeset(parameters)
    |> Repo.update()
  end

  @spec create_job(Source.t(), map()) :: {:error, Ecto.Changeset.t()} | {:ok, Job.t()}
  def create_job(source, params) do
    %Job{source: source}
    |> Job.changeset(params)
    |> Repo.insert()
  end

  @spec retry_job_entry(Job.Entry.t()) :: {:error, Ecto.Changeset.t()} | {:ok, Job.Entry.t()}
  def retry_job_entry(%Job.Entry{job: job, preset: preset} = job_entry) do
    %Job.Entry{parent: job_entry, job: job, preset: preset}
    |> Job.Entry.changeset()
    |> Repo.insert()
  end

  @spec update_job(Job.t(), map()) :: {:error, Ecto.Changeset.t()} | {:ok, Job.t()}
  def update_job(job, parameters) do
    job
    |> Job.changeset(parameters)
    |> Repo.update()
  end

  @spec get_job_entries(any()) :: [Job.Entry.t()] | []
  def get_job_entries(state) do
    Job.Entry
    |> Job.Entry.Scope.by(state)
    |> Repo.all()
  end
end
