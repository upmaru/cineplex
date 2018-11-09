defmodule Compressor.Queue.Job do
  use Ecto.Schema

  alias Compressor.Queue.Job.Entry

  schema "encode_jobs" do
    field :metadata, :map
    field :source, :string

    has_many :entries, Entry
  end
end
