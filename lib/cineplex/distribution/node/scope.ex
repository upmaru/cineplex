defmodule Cineplex.Distribution.Node.Scope do
  import Ecto.Query, only: [from: 2]

  @spec by(atom() | Ecto.Query.t(), [{:state, binary()}]) :: Ecto.Query.t()
  def by(queryable, state: state) do
    from(
      n in queryable,
      where: n.current_state == ^state
    )
  end

  @spec by(atom() | Ecto.Query.t(), binary, [{:state, binary()}]) :: Ecto.Query.t()
  def by(queryable, role, state: state) do
    from(
      n in queryable,
      where: n.current_state == ^state and n.role == ^role
    )
  end

  @spec except(atom() | Ecto.Query.t(), binary()) :: Ecto.Query.t()
  def except(queryable, name) do
    from(
      n in queryable,
      where: n.name != ^name
    )
  end
end
