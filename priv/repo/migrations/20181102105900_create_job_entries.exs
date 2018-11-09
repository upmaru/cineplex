defmodule Compressor.Repo.Migrations.CreateJobEntries do
  use Ecto.Migration

  def change do
    create table(:job_entries) do
      add :metadata, :map
      add :source, :string
    end
  end
end
