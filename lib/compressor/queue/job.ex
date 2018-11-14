defmodule Compressor.Queue.Job do
  use Ecto.Schema
  import Ecto.Changeset

  alias Compressor.Queue.{
    Job,
    Source
  }

  alias Job.Entry

  schema "queue_jobs" do
    field :object, :string
    field :resource, :string
    field :events_callback_url, :string

    belongs_to(:source, Source)

    has_many(:entries, Entry)
  end

  @valid_attrs ~w(resource object events_callback_url)a
  @required_attrs ~w(resource object)
  def changeset(job, params \\ %{}) do
    job
    |> cast(params, @valid_attrs)
    |> validate_required(@required_attrs)
    |> unique_constraint(:resource)
  end
end
