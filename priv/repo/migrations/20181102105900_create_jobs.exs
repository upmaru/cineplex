defmodule Compressor.Repo.Migrations.CreateJobs do
  use Ecto.Migration

  def change do
    create table(:jobs) do
      add :metadata, :map
      add :source, :string
    end
  end
end
