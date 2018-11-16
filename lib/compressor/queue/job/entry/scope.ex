defmodule Compressor.Queue.Job.Entry.Scope do
  import Ecto.Query, only: [from: 2]

  def by(queryable, :waiting) do
    from(
      e in queryable,
      where: is_nil(e.started_at) and is_nil(e.worker_id)
    )
  end
end
