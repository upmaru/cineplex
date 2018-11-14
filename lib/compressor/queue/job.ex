defmodule Compressor.Queue.Job do
  use Ecto.Schema
  import Ecto.Changeset

  alias Compressor.Queue.{
    Job,
    Source
  }

  alias Job.Entry

  schema "queue_jobs" do
    field :object, :string
    field :resource, :string
    field :events_callback_url, :string

    belongs_to(:source, Source)

    has_many(:entries, Entry)
  end

  def changeset(job, params \\ %{}) do
    job
    |> cast(params, [:metadata])
    |> validate_required([:metadata])
  end
end
