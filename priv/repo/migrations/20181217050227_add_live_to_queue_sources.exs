defmodule Cineplex.Repo.Migrations.AddLiveToQueueSources do
  use Ecto.Migration

  def change do
    alter table(:queue_sources) do
      add :live, :boolean, default: true
    end

    create index(:queue_sources, [:live])
  end
end
