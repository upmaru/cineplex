defmodule Cineplex.Reels.UpmaruStudio.Encode do
  alias Cineplex.Queue.Job
  alias Cineplex.Reels.UpmaruStudio.Encode

  alias Cineplex.Worker.Event

  alias Encode.{
    Setup,
    Download,
    Transcode,
    Store,
    Clean
  }

  @spec perform(Job.Entry.t()) :: {:ok, :encoded} | {:error, any()}
  def perform(%Job.Entry{job: job, preset: preset} = _job_entry) do
    with {:ok, url, path} <- setup(job, preset),
         {:ok, downloaded} <- download(job, preset, url, path),
         {:ok, transcoded} <- transcode(job, preset, downloaded),
         {:ok, :stored} <- store(job, preset, transcoded),
         {:ok, :cleaned} <- clean(job, preset, path) do
      {:ok, :encoded}
    else
      {:error, reason} ->
        Event.track(job, Atom.to_string(reason), %{preset_name: preset.name})
        {:error, reason}
    end
  end

  defp setup(job, preset) do
    Event.track(job, "setup", %{preset_name: preset.name})
    Setup.perform(job)
  end

  defp download(job, preset, url, path) do
    Event.track(job, "download", %{preset_name: preset.name})
    Download.perform(url, path)
  end

  defp transcode(job, preset, downloaded) do
    Event.track(job, "transcode", %{preset_name: preset.name})
    Transcode.perform(preset, downloaded)
  end

  defp store(%Job{source: source} = job, preset, transcoded) do
    Event.track(job, "store", %{preset_name: preset.name})
    Store.perform(source, preset, transcoded)
  end

  defp clean(job, preset, path) do
    Event.track(job, "clean", %{preset_name: preset.name})
    Clean.perform(path)
  end
end
