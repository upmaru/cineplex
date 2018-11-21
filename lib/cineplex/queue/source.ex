defmodule Cineplex.Queue.Source do
  use Ecto.Schema
  import Ecto.Changeset

  alias Cineplex.Queue.{
    Job,
    Source
  }

  alias Source.Preset

  schema "queue_sources" do
    field(:name, :string)
    field(:endpoint, :string)
    field(:pipeline, :string)
    field(:token, :string)

    field(:storage, :map)

    has_many(:presets, Preset)
    has_many(:jobs, Job)

    timestamps(type: :utc_datetime)
  end

  @valid_attrs ~w(endpoint pipeline token storage)a
  @required_attrs ~w(endpoint pipeline token)a

  def changeset(source, params \\ %{}) do
    source
    |> cast(params, @valid_attrs)
    |> validate_required(@required_attrs)
    |> unique_constraint(:endpoint)
  end
end
