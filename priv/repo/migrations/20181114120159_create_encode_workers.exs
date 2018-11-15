defmodule Compressor.Repo.Migrations.CreateEncodeWorkers do
  use Ecto.Migration

  def change do
    create table(:encode_workers) do
      add :hostname, :string
      add :address, :inet
      add :current_state, :string

      add :job_entry_id, references(:queue_job_entries)

      timestamps()
    end

    create index(:encode_workers, [:job_entry_id])
    create index(:encode_workers, [:address], unique: true)
  end
end
