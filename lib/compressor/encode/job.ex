defmodule Compressor.Encode.Job do
  use Ecto.Schema

  alias Compressor.Encode.Job.Entry

  schema "encode_jobs" do
    field :metadata, :map
    field :source, :string

    has_many :entries, Entry
  end
end
