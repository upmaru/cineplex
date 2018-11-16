defmodule Compressor.Distribution.Worker do
  use Ecto.Schema
  import Ecto.Changeset

  alias Compressor.Queue.Job

  @valid_current_states ~w(ready unavailable working)

  schema "distribution_workers" do
    field(:node_name, :string)
    field(:current_state, :string)

    has_one(:entry, Job.Entry)

    timestamps(type: :utc_datetime)
  end

  @spec changeset(
          {map(), map()}
          | %{:__struct__ => atom() | %{__changeset__: map()}, optional(atom()) => any()},
          :invalid | %{optional(:__struct__) => none(), optional(atom() | binary()) => any()}
        ) :: Ecto.Changeset.t()
  def changeset(worker, params \\ %{}) do
    worker
    |> cast(params, [:node_name, :current_state])
    |> validate_required([:node_name, :current_state])
    |> validate_inclusion(:current_state, @valid_current_states)
    |> unique_constraint(:node_name)
  end
end
