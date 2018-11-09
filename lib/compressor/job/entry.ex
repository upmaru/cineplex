defmodule Compressor.Job.Entry do
  use Ecto.Schema

  schema "job_entries" do
    field :metadata, :map
    field :source, :string
  end
end
