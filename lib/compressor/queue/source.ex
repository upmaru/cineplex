defmodule Compressor.Queue.Source do
  use Ecto.Schema
  import Ecto.Changeset

  alias Compressor.Queue.Job

  schema "queue_sources" do
    field(:name, :string)
    field(:endpoint, :string)

    field(:presets, {:array, :map})
    field(:storage, :map)

    has_many(:jobs, Job)
  end
end
