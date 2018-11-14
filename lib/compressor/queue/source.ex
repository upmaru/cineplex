defmodule Compressor.Queue.Source do
  use Ecto.Schema
  import Ecto.Changeset

  alias Compressor.Queue.{
    Job,
    Source
  }

  alias Source.Preset

  schema "queue_sources" do
    field(:name, :string)
    field(:endpoint, :string)
    field(:adapter, :string)
    field(:token, :string)

    field(:storage, :map)

    has_many(:presets, Preset)
    has_many(:jobs, Job)
  end

  @valid_attrs ~w(endpoint adapter token storage)a
  @required_attrs ~w(endpoint adapter token)a

  def changeset(source, params \\ %{}) do
    source
    |> cast(params, @valid_attrs)
    |> validate_required(@required_attrs)
    |> unique_constraint(:endpoint)
  end
end
