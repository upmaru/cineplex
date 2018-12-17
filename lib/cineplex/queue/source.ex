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
    field(:reel, :string)
    field(:token, :string)
    field(:live, :boolean)

    field(:storage, :map)

    has_many(:presets, Preset)
    has_many(:jobs, Job)

    timestamps(type: :utc_datetime)
  end

  @valid_attrs ~w(endpoint reel token storage live)a
  @required_attrs ~w(endpoint reel token)a

  @spec changeset(
          {map(), map()}
          | %{:__struct__ => atom() | %{__changeset__: map()}, optional(atom()) => any()},
          :invalid | %{optional(:__struct__) => none(), optional(atom() | binary()) => any()}
        ) :: Ecto.Changeset.t()
  def changeset(source, params \\ %{}) do
    source
    |> cast(params, @valid_attrs)
    |> validate_required(@required_attrs)
    |> unique_constraint(:endpoint)
  end
end
