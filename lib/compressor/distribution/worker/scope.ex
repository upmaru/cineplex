defmodule Compressor.Distribution.Worker.Scope do
  import Ecto.Query, only: [from: 2]

  @spec by(atom(), [{:state, binary()}]) :: Ecto.Query.t()
  def by(queryable, state: state) do
    from(
      w in queryable,
      where: w.current_state == ^state
    )
  end
end
