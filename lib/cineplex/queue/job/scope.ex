defmodule Cineplex.Queue.Job.Scope do
  import Ecto.Query, only: [from: 2]

  alias Cineplex.Queue.Source

  @spec by(any(), Source.t()) :: Ecto.Query.t()
  def by(queryable, %Source{id: source_id} = _source) do
    from(
      j in queryable,
      where: j.source_id == ^source_id,
      preload: [:source]
    )
  end
end
