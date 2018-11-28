defmodule Cineplex.Repo.Migrations.CreateQueueSourcePresets do
  use Ecto.Migration

  def change do
    create table(:queue_source_presets) do
      add :name, :string
      add :parameters, :map

      add :source_id, references(:queue_sources)

      timestamps()
    end

    create index(:queue_source_presets, [:source_id])
    create index(:queue_source_presets, [:name, :source_id], unique: true)
  end
end
