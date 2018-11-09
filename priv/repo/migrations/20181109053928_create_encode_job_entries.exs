defmodule Compressor.Repo.Migrations.CreateEncodeJobEntries do
  use Ecto.Migration

  def change do
    create table(:encode_job_entries) do
      add :name, :string
      add :parameters, :map
      add :job_id, references(:encode_jobs)
    end

    create index(:encode_job_entries, [:job_id])
  end
end
