defmodule Cineplex.Worker.Begin do
  alias Cineplex.{
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
      {:ok, %{job_entry: assigned_job_entry, node: _working_worker}} ->
        assigned_job_entry_with_source = Repo.preload(assigned_job_entry, [job: [:source]])
        reel = Cineplex.Reel.from_source(assigned_job_entry_with_source.job.source)
        reel.task(assigned_job_entry)
      _ ->
        {:error, :starting}
    end
  end

  defp assign_job_entry_to_self(job_entry) do
    myself = Distribution.get_worker(name: Atom.to_string(node()))

    Multi.new()
    |> Multi.update(:job_entry, assignment_changeset(job_entry, myself))
    |> Multi.update(:node, working_changeset(myself))
    |> Repo.transaction()
  end

  defp assignment_changeset(job_entry, %Distribution.Node{id: id} = _myself) do
    Job.Entry.changeset(job_entry, %{node_id: id, started_at: DateTime.utc_now()})
  end

  defp working_changeset(myself) do
    Distribution.Node.changeset(myself, %{current_state: "working"})
  end
end
