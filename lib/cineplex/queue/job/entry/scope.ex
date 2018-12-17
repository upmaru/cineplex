defmodule Cineplex.Queue.Job.Entry.Scope do
  import Ecto.Query, only: [from: 2]

  @spec by(any(), :waiting) :: Ecto.Query.t()
  def by(queryable, :waiting) do
    from(
      e in queryable,
      join: j in assoc(e, :job),
      join: s in assoc(j, :source),
      where: s.live == true,
      where: is_nil(e.started_at) and is_nil(e.node_id),
      preload: [:preset, job: {j, [source: s]}]
    )
  end
end
