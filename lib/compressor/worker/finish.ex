defmodule Compressor.Worker.Finish do
  alias Compressor.{
    Distribution, Queue, Repo
  }

  alias Queue.Job

  alias Ecto.Multi

  @spec perform(
          {map(), map()}
          | %{:__struct__ => atom() | %{__changeset__: map()}, optional(atom()) => any()}
        ) :: any()
  def perform(job_entry) do
    myself = Distribution.get_worker(node_name: Atom.to_string(node()))

    Multi.new
    |> Multi.update(:job_entry, finish_changeset(job_entry))
    |> Multi.update(:worker, ready_changeset(myself))
    |> Repo.transaction()
  end

  defp finish_changeset(job_entry) do
    Job.Entry.changeset(job_entry, %{finished_at: DateTime.utc_now()})
  end

  defp ready_changeset(worker) do
    Distribution.Worker.changeset(worker, %{current_state: "ready"})
  end
end
