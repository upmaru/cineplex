defmodule Compressor.Worker.Begin do
  alias Compressor.{
    Distribution, Repo, Queue
  }

  alias Queue.Job
  alias Ecto.Multi

  @spec perform(
          {map(), map()}
          | %{:__struct__ => atom() | %{__changeset__: map()}, optional(atom()) => any()}
        ) :: any()
  def perform(job_entry) do
    case assign_job_entry_to_self(job_entry) do
      {:ok, %{job_entry: assigned_job_entry, worker: _working_worker}} ->
        assigned_job_entry_with_source = Repo.preload(assigned_job_entry, [job: [:source]])
        adapter = Compressor.Adapter.from_source(assigned_job_entry_with_source.job.source)
        adapter.work(assigned_job_entry)
      _ ->
        {:error, :starting}
    end
  end

  defp assign_job_entry_to_self(job_entry) do
    myself = Distribution.get_worker(node_name: Atom.to_string(node()))

    Multi.new()
    |> Multi.update(:job_entry, assignment_changeset(job_entry, myself))
    |> Multi.update(:worker, working_changeset(myself))
    |> Repo.transaction()
  end

  defp assignment_changeset(job_entry, %Distribution.Worker{id: id} = _worker) do
    Job.Entry.changeset(job_entry, %{worker_id: id, started_at: DateTime.utc_now()})
  end

  defp working_changeset(worker) do
    Distribution.Worker.changeset(worker, %{current_state: "working"})
  end
end
