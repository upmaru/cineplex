defmodule Compressor.Repo.Migrations.CreateQueueJobEntries do
  use Ecto.Migration

  def change do
    create table(:queue_job_entries) do
      add :job_id, references(:queue_jobs)
      add :preset_id, references(:queue_source_presets)

      add :started_at, :utc_datetime
      add :finished_at, :utc_datetime

      add :worker_id, references(:encode_workers)

      timestamps()
    end

    create index(:queue_job_entries, [:worker_id], unique: true)
    create index(:queue_job_entries, [:job_id, :preset_id])
  end
end
