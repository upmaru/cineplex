defmodule Compressor.Queue.Source do
  use Ecto.Schema
  import Ecto.Changeset

  alias Compressor.Queue.{
    Job, Source
  }

  alias Source.Preset

  schema "queue_sources" do
    field(:name, :string)
    field(:endpoint, :string)

    field(:storage, :map)

    has_many(:presets, Preset)
    has_many(:jobs, Job)
  end
end
