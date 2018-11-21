defmodule Compressor.Pipelines.UpmaruStudio.Encode do
  alias Compressor.Queue.Job
  alias Compressor.Pipelines.UpmaruStudio.Encode

  alias Encode.{
    Setup, Download, Transcode, Store, Clean
  }

  @spec perform(Job.Entry.t()) :: {:ok, :encoded} | {:error, any()}
  def perform(%Job.Entry{job: job, preset: preset} = _job_entry) do
    with {:ok, url, path} <- Setup.perform(job),
         {:ok, downloaded} <- Download.perform(url, path),
         {:ok, transcoded} <- Transcode.perform(preset, downloaded),
         {:ok, :stored} <- Store.perform(job.source, preset, transcoded),
         {:ok, :cleaned} <- Clean.perform(path)
    do
      {:ok, :encoded}
    else
      {:error, reason} -> {:error, reason}
    end
  end
end
