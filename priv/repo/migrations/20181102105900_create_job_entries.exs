defmodule Compressor.Repo.Migrations.CreateQueueJobs do
  use Ecto.Migration

  def change do
    create table(:queue_jobs) do
      add :metadata, :map
      add :source, :string
    end
  end
end
