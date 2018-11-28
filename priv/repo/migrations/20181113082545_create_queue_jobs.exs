defmodule Cineplex.Repo.Migrations.CreateQueueJobs do
  use Ecto.Migration

  def change do
    create table(:queue_jobs) do
      add :resource, :string
      add :object, :string
      add :events_callback_url, :string

      add :source_id, references(:queue_sources)

      timestamps()
    end

    create index(:queue_jobs, [:source_id])
    create index(:queue_jobs, [:resource], unique: true)
  end
end
