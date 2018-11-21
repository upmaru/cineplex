defmodule Cineplex.Repo.Migrations.CreateQueueJobEntries do
  use Ecto.Migration

  def change do
    create table(:queue_job_entries) do
      add :job_id, references(:queue_jobs)
      add :preset_id, references(:queue_source_presets)

      add :started_at, :utc_datetime
      add :finished_at, :utc_datetime

      add :node_id, references(:distribution_nodes)
      add :parent_id, references(:queue_job_entries)

      timestamps()
    end

    create index(:queue_job_entries, [:node_id])
    create index(:queue_job_entries, [:parent_id])
    create index(:queue_job_entries, [:job_id, :preset_id])
  end
end
