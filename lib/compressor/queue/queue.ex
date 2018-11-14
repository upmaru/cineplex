defmodule Compressor.Queue do
  alias Compressor.Queue.{
    Job,
    Source
  }

  alias Compressor.Repo

  @spec create_source(binary(), binary(), binary()) :: {:error, Ecto.Changeset.t()} | {:ok, Source.t()}
  def create_source(endpoint, token, adapter) do
    %Source{}
    |> Source.changeset(%{endpoint: endpoint, token: token, adapter: adapter})
    |> Repo.insert()
  end

  @spec update_source(Source.t(), map()) :: {:error, Ecto.Changeset.t()} | {:ok, Source.t()}
  def update_source(source, parameters) do
    source
    |> Source.changeset(parameters)
    |> Repo.update()
  end

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
end
