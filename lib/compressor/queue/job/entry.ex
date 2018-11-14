defmodule Compressor.Queue.Job.Entry do
  use Ecto.Schema

  alias Compressor.Queue.{
    Job,
    Source
  }

  schema "queue_job_entries" do
    belongs_to(:preset, Source.Preset)
    belongs_to(:job, Job)

    field :started_at, :utc_datetime
    field :finished_at, :utc_datetime

    timestamps(type: :utc_datetime)
  end
end
