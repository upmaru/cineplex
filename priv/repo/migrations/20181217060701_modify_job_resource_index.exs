defmodule Cineplex.Repo.Migrations.ModifyJobResourceIndex do
  use Ecto.Migration

  def change do
    drop index(:queue_jobs, [:resource], unique: true)
    create index(:queue_jobs, [:resource, :source_id], unique: true)
  end
end
