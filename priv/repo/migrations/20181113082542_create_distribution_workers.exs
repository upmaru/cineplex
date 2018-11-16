defmodule Compressor.Repo.Migrations.CreateDistributionWorkers do
  use Ecto.Migration

  def change do
    create table(:distribution_workers) do
      add :node_name, :string
      add :current_state, :string

      timestamps()
    end

    create index(:distribution_workers, [:node_name], unique: true)
  end
end
