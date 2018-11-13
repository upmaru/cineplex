defmodule Compressor.Repo.Migrations.CreateQueueJobs do
  use Ecto.Migration

  def change do
    create table(:queue_jobs) do
      add :metadata, :map
      add :source_id, references(:queue_sources)
    end

    create index(:queue_sources, [:source_id])
  end
end
