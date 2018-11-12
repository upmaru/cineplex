defmodule Compressor.Queue.Job do
  use Ecto.Schema

  alias Compressor.Queue.Job.Entry

  schema "queue_jobs" do
    field :metadata, :map
    field :source, :string

    has_many :entries, Entry
  end
end
