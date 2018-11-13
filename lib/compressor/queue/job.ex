defmodule Compressor.Queue.Job do
  use Ecto.Schema
  import Ecto.Changeset

  alias Compressor.Queue.{
    Job,
    Source
  }

  alias Job.Entry

  schema "queue_jobs" do
    field(:metadata, :map)

    belongs_to(:source, Source)

    has_many(:entries, Entry)
  end

  def changeset(job, params \\ %{}) do
    job
    |> cast(params, [:metadata])
    |> validate_required([:metadata])
  end
end
