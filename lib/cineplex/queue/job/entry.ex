defmodule Cineplex.Queue.Job.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  alias Cineplex.Queue.{
    Job,
    Source
  }

  alias Cineplex.Distribution

  schema "queue_job_entries" do
    belongs_to(:job, Job)
    belongs_to(:preset, Source.Preset)

    field(:started_at, :utc_datetime)
    field(:finished_at, :utc_datetime)

    belongs_to(:worker, Distribution.Worker)

    timestamps(type: :utc_datetime)
  end

  @spec changeset(
          {map(), map()}
          | %{:__struct__ => atom() | %{__changeset__: map()}, optional(atom()) => any()},
          :invalid | %{optional(:__struct__) => none(), optional(atom() | binary()) => any()}
        ) :: Ecto.Changeset.t()
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:started_at, :finished_at, :worker_id])
    |> cast_assoc(:worker)
  end
end
