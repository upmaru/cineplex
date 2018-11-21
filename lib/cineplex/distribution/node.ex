defmodule Cineplex.Distribution.Node do
  use Ecto.Schema
  import Ecto.Changeset

  alias Cineplex.Queue.Job

  @valid_current_states ~w(ready unavailable working)
  @valid_roles ~w(server worker)

  schema "distribution_nodes" do
    field(:name, :string)
    field(:current_state, :string)
    field(:role, :string)

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
    |> cast(params, [:name, :current_state, :role])
    |> validate_required([:name, :current_state, :role])
    |> validate_inclusion(:current_state, @valid_current_states)
    |> validate_inclusion(:role, @valid_roles)
    |> unique_constraint(:name)
  end
end
