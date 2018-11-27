defmodule Cineplex.Worker.Finish do
  alias Cineplex.{
    Distribution,
    Queue,
    Repo,
    Worker
  }

  alias Queue.Job
  alias Worker.Event

  alias Ecto.Multi

  @spec perform(
          {map(), map()}
          | %{:__struct__ => atom() | %{__changeset__: map()}, optional(atom()) => any()}
        ) :: any()
  def perform(%Job.Entry{job: job, preset: _preset} = job_entry) do
    myself = Distribution.get_worker(name: Atom.to_string(node()))

    Multi.new()
    |> Multi.update(:job_entry, finish_changeset(job_entry))
    |> Multi.update(:worker, ready_changeset(myself))
    |> Repo.transaction()

    if job_finished?(job) do
      Event.track(job, "finish")
    end
  end

  defp job_finished?(job) do
    job = Repo.preload(job, [:unfinished_entries])
    Enum.count(job.unfinished_entries) == 0
  end

  defp finish_changeset(job_entry) do
    Job.Entry.changeset(job_entry, %{finished_at: DateTime.utc_now()})
  end

  defp ready_changeset(worker) do
    Distribution.Node.changeset(worker, %{current_state: "ready"})
  end
end
