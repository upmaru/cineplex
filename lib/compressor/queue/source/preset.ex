defmodule Compressor.Queue.Source.Preset do
  use Ecto.Schema

  alias Compressor.Queue.{
    Source,
    Job
  }

  schema "queue_source_presets" do
    field(:name, :string)
    field(:parameters, :map)

    belongs_to(:source, Source)

    has_many(:entries, Job.Entry)

    timestamps(type: :utc_datetime)
  end
end
