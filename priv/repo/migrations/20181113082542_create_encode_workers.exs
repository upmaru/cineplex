defmodule Compressor.Repo.Migrations.CreateEncodeWorkers do
  use Ecto.Migration

  def change do
    create table(:encode_workers) do
      add :node_name, :string
      add :current_state, :string

      timestamps()
    end

    create index(:encode_workers, [:node_name], unique: true)
  end
end
