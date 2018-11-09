defmodule Compressor.Repo.Migrations.CreateQueueJobEntries do
  use Ecto.Migration

  def change do
    create table(:queue_job_entries) do
      add :name, :string
      add :parameters, :map
      add :job_id, references(:queue_jobs)
    end

    create index(:queue_job_entries, [:job_id])
  end
end
