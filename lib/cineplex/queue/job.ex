defmodule Cineplex.Queue.Job do
  use Ecto.Schema
  import Ecto.Changeset

  alias Cineplex.Queue.{
    Job,
    Source
  }

  alias Job.Entry

  schema "queue_jobs" do
    field(:object, :string)
    field(:resource, :string)
    field(:events_callback_url, :string)

    belongs_to(:source, Source)

    has_many(:entries, Entry)

    has_many(
      :parent_entries,
      Entry,
      where: {Job.Entry, :parent_only, []}
    )

    has_many(
      :unfinished_entries,
      Entry,
      where: {Job.Entry, :unfinished, []}
    )

    timestamps(type: :utc_datetime)
  end

  @valid_attrs ~w(resource object events_callback_url)a
  @required_attrs ~w(resource object)a
  @spec changeset(
          {map(), map()}
          | %{:__struct__ => atom() | %{__changeset__: map()}, optional(atom()) => any()},
          :invalid | %{optional(:__struct__) => none(), optional(atom() | binary()) => any()}
        ) :: Ecto.Changeset.t()
  def changeset(job, params \\ %{}) do
    job
    |> cast(params, @valid_attrs)
    |> validate_required(@required_attrs)
    |> unique_constraint(:resource_source_constraint, name: :queue_jobs_resource_source_id_index)
  end
end
