defmodule Cineplex.Queue.Job.Extract do
  alias Cineplex.{
    Queue,
    Repo
  }

  alias Queue.Job

  @spec perform(Job.t()) :: {:ok, %{job: Job.t(), entries: [Job.Entry.t()]}}
  def perform(%Job{source: source} = job) do
    source = Repo.preload(source, [:presets])
    job = Repo.preload(job, [:parent_entries])

    entries = Enum.map(source.presets, &entry_from_preset(&1, job))

    {_count, created_entries} = Repo.insert_all(Job.Entry, entries)

    {:ok, %{job: job, entries: created_entries}}
  end

  defp entry_from_preset(preset, job) do
    timestamp = DateTime.truncate(DateTime.utc_now(), :second)

    parent_entry =
      job.parent_entries
      |> Enum.filter(fn e -> e.preset_id == preset.id end)
      |> List.first()

    base_entry = %{
      preset_id: preset.id,
      job_id: job.id,
      inserted_at: timestamp,
      updated_at: timestamp
    }

    if parent_entry do
      Map.merge(base_entry, %{parent_id: parent_entry.id})
    else
      base_entry
    end
  end
end
