defmodule Compressor.Encode.Worker do
  use Ecto.Schema

  alias Compressor.Queue.Job

  schema "encode_workers" do
    field :hostname, :string
    field :address, EctoNetwork.INET

    field :current_state, :string

    belongs_to :job_entry, Job.Entry

    timestamps(type: :utc_datetime)
  end
end
