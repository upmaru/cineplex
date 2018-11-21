defmodule Cineplex.Repo.Migrations.CreateDistributionNodes do
  use Ecto.Migration

  def change do
    create table(:distribution_nodes) do
      add :name, :string
      add :current_state, :string
      add :role, :string

      timestamps()
    end

    create index(:distribution_nodes, [:name], unique: true)
  end
end
