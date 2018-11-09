defmodule Compressor.Encode.Job.Entry do
  use Ecto.Schema

  alias Compressor.Encode.Job

  schema "encode_job_entries" do
    field :name, :string
    field :parameter, :map

    belongs_to :job, Job
  end
end
