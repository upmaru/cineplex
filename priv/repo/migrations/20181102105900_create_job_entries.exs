defmodule Compressor.Repo.Migrations.CreateEncodeJobs do
  use Ecto.Migration

  def change do
    create table(:encode_jobs) do
      add :metadata, :map
      add :source, :string
    end
  end
end
