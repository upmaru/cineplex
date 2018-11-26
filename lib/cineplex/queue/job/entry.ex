defmodule Cineplex.Queue.Job.Entry do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [dynamic: 2]

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

    belongs_to(:node, Distribution.Node)
    belongs_to(:parent, __MODULE__)

    has_many(:retries, __MODULE__, foreign_key: :parent_id)

    timestamps(type: :utc_datetime)
  end

  @spec changeset(
          {map(), map()}
          | %{:__struct__ => atom() | %{__changeset__: map()}, optional(atom()) => any()},
          :invalid | %{optional(:__struct__) => none(), optional(atom() | binary()) => any()}
        ) :: Ecto.Changeset.t()
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:started_at, :finished_at, :node_id])
    |> cast_assoc(:node)
  end

  @spec parent_only() :: Ecto.Query.DynamicExpr.t()
  def parent_only, do: dynamic([entry], is_nil(entry.parent_id))
end
