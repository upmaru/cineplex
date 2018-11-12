defmodule Compressor.Queue.Job.Entry do
  use Ecto.Schema

  alias Compressor.Queue.Job

  schema "queue_job_entries" do
    field(:name, :string)
    field(:parameter, :map)

    belongs_to(:job, Job)
  end
end
