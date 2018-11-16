defmodule Compressor.Queue.Job.Extract do
  alias Compressor.{
    Queue,
    Repo
  }

  alias Queue.Job

  @spec perform(Job.t()) :: {:ok, %{job: Job.t(), entries: [Job.Entry.t()]}}
  def perform(%Job{source: source} = job) do
    source = Repo.preload(source, [:presets])

    entries = Enum.map(source.presets, &entry_from_preset(&1, job))

    {_count, created_entries} = Repo.insert_all(Job.Entry, entries)

    {:ok, %{job: job, entries: created_entries}}
  end

  defp entry_from_preset(preset, job) do
    timestamp = DateTime.truncate(DateTime.utc_now(), :second)

    %{preset_id: preset.id, job_id: job.id, inserted_at: timestamp, updated_at: timestamp}
  end
end
