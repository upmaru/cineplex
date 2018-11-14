defmodule Compressor.Queue.Source.Preset do
  use Ecto.Schema

  alias Compressor.Queue.Source

  schema "queue_source_presets" do
    field :name, :string
    field :parameters, :map

    belongs_to :source, Source
  end
end
