defmodule Compressor.Queue.Job do
  use Ecto.Schema
  import Ecto.Changeset

  alias Compressor.Queue.Job.Entry

  schema "queue_jobs" do
    field(:metadata, :map)
    field(:source, :string)

    has_many(:entries, Entry)
  end

  def changeset(job, params \\ %{}) do
    job
    |> cast(params, [:metadata, :source])
    |> validate_required([:metadata, :source])
  end
end
