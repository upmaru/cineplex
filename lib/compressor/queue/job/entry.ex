defmodule Compressor.Queue.Job.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  alias Compressor.Queue.Job

  schema "queue_job_entries" do
    field(:name, :string)
    field(:parameter, :map)

    belongs_to(:job, Job)
  end

  def changeset(entry, params \\ %{}) do
    entry
    |> cast(params, [:name, :parameters])
    |> validate_required([:name, :parameters])
  end
end
