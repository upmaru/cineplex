defmodule Compressor.Queue.Job.Entry do
  use Ecto.Schema

  alias Compressor.Queue.{
    Job, Source
  }

  schema "queue_job_entries" do
    belongs_to(:preset, Source.Preset)
    belongs_to(:job, Job)
  end
end
