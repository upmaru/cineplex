defmodule Compressor.Queue.Job.Entry do
  use Ecto.Schema

  alias Compressor.Queue.{
    Job,
    Source
  }

  alias Compressor.Encode

  schema "queue_job_entries" do
    belongs_to(:job, Job)
    belongs_to(:source_preset, Source.Preset)

    field :started_at, :utc_datetime
    field :finished_at, :utc_datetime

    has_one(:encode_worker, Encode.Worker)

    timestamps(type: :utc_datetime)
  end
end
